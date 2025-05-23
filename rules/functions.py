import errno
import multiprocessing
import os.path
import psutil


def _gatk_multi_arg(flag, args):
    flag += " "
    return " ".join(flag + arg for arg in args)

def _multi_flag(arguments):
    if arguments:
        return " ".join(flag + " " + arg for flag, arg in arguments)
    return ''

def _multi_flag_dbi(flag, arguments):
    if arguments:
        return " ".join(flag + " " + arg for arg in arguments)
    return ''

def _get_samples_set(samples_files, flag='-sn'):   #the file must be .args before was -sf, deprecated from gatk4
    arguments = []
    set_arg=config.get("sample_set", None)
    if set_arg and set_arg in samples_files:
        return "".join(flag + " " + samples_files[set_arg])
    for samples_set in samples_files.keys():
        arguments.append("".join(flag + " " + samples_files[samples_set]))
    return ' '.join(arguments)

def total_physical_mem_size():
    mem = psutil.virtual_memory()
    return mem.total

def cpu_count():
    return multiprocessing.cpu_count()

def conservative_cpu_count(reserve_cores=1, max_cores=5):
    cores = max_cores if cpu_count() > max_cores else cpu_count()
    return max(cores - reserve_cores, 1)

def tmp_path(path=''):
    """
    if does not exists, create path and return it. If any errors, return
    default path
    :param path: path
    :return: path
    """
    default_path = os.getenv('TMPDIR', '/tmp')
    if path:
        try:
            os.makedirs(path)
        except OSError as e:
            if e.errno != errno.EEXIST:
                return default_path
        return path
    return default_path

def java_params(tmp_dir='', percentage_to_preserve=20, stock_mem=1024 ** 3,
                stock_cpu=2, multiply_by=1):
    """
    Set Java params
    :param tmp_dir: path to tmpdir
    :param percentage_to_preserve: percentage of resources to preserve
    :param stock_mem: min memory to preserve
    :param stock_cpu: min cpu to preserve
    :param multiply_by: multiply base resource by this param
    :return: string to return to configure java environments
    """

    def bytes2human(n):
        # http://code.activestate.com/recipes/578019
        # >>> bytes2human(10000)
        # '9.8K'
        # >>> bytes2human(100001221)
        # '95.4M'
        symbols = ('K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y')
        prefix = {}
        for i, s in enumerate(symbols):
            prefix[s] = 1 << (i + 1) * 10
        for s in reversed(symbols):
            if n >= prefix[s]:
                value = float(n) / prefix[s]
                return '%.0f%s' % (value, s)
        return "%sB" % n

    def preserve(resource, percentage, stock):
        return resource - max(resource * percentage // 100, stock)

    params_template = "'-Xms{} -Xmx{} -XX:ParallelGCThreads={} " \
                      "-Djava.io.tmpdir={}'"

    mem_min = 1024 ** 3 * 2  # 2GB

    mem_size = preserve(total_physical_mem_size(), percentage_to_preserve,
                        stock_mem)

    cpu_nums = preserve(cpu_count(), percentage_to_preserve, stock_cpu)

    tmpdir = tmp_path(tmp_dir)

    return params_template.format(bytes2human(mem_min).lower(),
                                  bytes2human(max(mem_size//cpu_nums*multiply_by,
                                                  mem_min)).lower(),
                                  min(cpu_nums, multiply_by),
                                  tmpdir)

def references_abs_path(ref='references'):
    references = config.get(ref)
    basepath = references['basepath']
    provider = references['provider']
    release = references['release']

    return [os.path.join(basepath, provider, release)]

def resolve_single_filepath(basepath, filename):
    return [os.path.join(basepath, filename)]

def resolve_multi_filepath(basepath, dictionary):
    for k, v in dictionary.items():
        dictionary[k] = os.path.join(basepath, v)
    return dictionary

def get_references_label(ref='references'):
    references = config.get(ref)
    provider = references['provider']
    genome = references['release']

    return '_'.join([provider, genome])

def get_units_by_sample(wildcards, samples, label='units', prefix='before',
                        suffix='after'):
    # Force index to string to avoid error with numbers as sample names (e.g. 123)
    samples.index = samples.index.map(str)
    return [prefix+i+suffix for i in samples.loc[wildcards.sample,
                                                  [label]][0].split(',')]
def get_odp(wildcards,samples,optical_dup='odp'):
    return "OPTICAL_DUPLICATE_PIXEL_DISTANCE={}".format(samples.loc[wildcards.sample, [optical_dup]].dropna()[0])

def get_kit_col_value(kit_name, col):
    value = []
    if len(kits.loc[kit_name, [col]].dropna()) > 0:
        value = resolve_single_filepath(*references_abs_path(), kits.loc[kit_name, [col]].dropna()[0])
    return value

def get_kit(wildcards,samples,enrichment_kit='kit', specific_kit=None):
    kit_name= specific_kit if specific_kit else samples.loc[wildcards.sample, [enrichment_kit]].dropna()[0]
    hsprobes = get_kit_col_value(kit_name, "hsProbes")
    hstarget = get_kit_col_value(kit_name, "hsTarget")
    cnvTarget = get_kit_col_value(kit_name, "cnvTarget")
    cnvAntitarget = get_kit_col_value(kit_name, "cnvAntitarget")
    cnvRef =get_kit_col_value(kit_name, "cnvRef")
    return hsprobes,hstarget,cnvTarget,cnvAntitarget,cnvRef

