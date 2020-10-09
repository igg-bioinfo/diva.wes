Annotation	Description	Source
CHROM	Chromosome Number	vcf
POS	Hg38 Genome Position	vcf
ID	Dbsnp Identifier V138	vcf
REF	Reference Allele	vcf
ALT	Alternative Allele	vcf
QUAL	Thephred-Scaledprobability That A Ref/Alt Polymorphism Exists At This Site Given Sequencing Data. Because The Phred Scale Is -10 * Log(1-P), A Value Of 10 Indicates A 1 In 10 Chance Of Error, While A 100 Indicates A 1 In 10^10 Chance. These Values Can Grow Very Large When A Large Amount Of Data Is Used For Variant Calling, So Qual Is Not Often A Very Useful Property For Evaluating The Quality Of A Variant Call.	GATK
FILTER	This Field Contains The Name(S) Of Any Filter(S) That The Variant Fails To Pass, Or The Valuepassif The Variant Passed All Filters. If The Filter Value Is., Then No Filtering Has Been Applied To The Records.	GATK
MQ	Rms Mapping Quality	vcf
QD	Variant Confidence/Quality By Depth.	vcf
DP	Dpis The Filtered Depth, At The Sample Level. This Gives You The Number Of Filtered Reads That Support Each Of The Reported Alleles.	GATK
FS	Phred-Scaled P-Value Using Fisher's Exact Test To Detect Strand Bias	
SOR	Symmetric Odds Ratio Of 2x2 Contingency Table To Detect Strand Bias	
ExcessHet	Phred-Scaled P-Value For Exact Test Of Excess Heterozygosity. This Annotation Estimates The Probability Of The Called Samples Exhibiting Excess Heterozygosity With Respect To The Null Hypothesis That The Samples Are Unrelated. The Higher The Score, The Higher The Chance That The Variant Is A Technical Artifact Or That There Is Consanguinuity Among The Samples.	GATK
VQSLOD	This Score Is The Log Odds Of Being A True Variant Versus Being False Under The Trained Gaussian Mixture Model.	GATK
culprit	(Vqsr) The Annotation Which Was The Worst Performing In The Gaussian Mixture Model, Likely The Reason Why The Variant Was Filtered Out.	GATK
Cases	Number of homozygous alleles, number of heterozygous alleles, total alleles (for Cases as defined in the PED file). Eg Cases=1,2,4 is 1 homozygous, 2 heterozygous, and a total of 4 variants (2 * 1 + 1 * 2 = 4).	snpSift
Controls	Number of homozygous alleles, number of heterozygous alleles, total alleles (for Controls as defined in the PED file). Eg Controls=2,2,6 is 2 homozygous, 2 heterozygous, and a total of 6 variants (2 * 2 + 1 * 2 = 6)	snpSift
FORMAT	List Of Fields For Describing The Samples (GT:AD:DP:GQ:PL)	vcf
Sample 1	Sample Name	vcf
Sample n	Sample Name	vcf
Allele	Alternative Allele	VEP
Consequence	Consequenceof Your Variants On The Protein Sequence (E.G. Stop Gained, Missense, Stop Lost, Frameshift)	VEP
IMPACT	Impact Classification Of Consequence Type	VEP
SYMBOL	Gene Symbol (Hgnc Identifier)	VEP
Gene	Ensg Identifier (Gene)	VEP
Feature_type	Ensembl Automatic Annotation System Classification	VEP
Feature	Enst Identifier (Transcript)	VEP
BIOTYPE	Protein Coding, Pseudogene, Long Noncoding And Short Noncoding	VEP
EXON	Where The Variant Is Located In The Gene (Number Of Exons/Total Of Exons)	VEP
INTRON	Where The Variant Is Located In The Gene (Number Of Introns/Total Of Introns)	VEP
HGVSc	Hgvs Nomenclature Based On Ensembl_Coding Sequence	VEP
HGVSp	Hgvs Nomenclature Based On Ensembl_Protein Sequence	VEP
cDNA_position	Relative Position Of Base Pair In Cdna Sequence	VEP
CDS_position	Relative Position Of Base Pair In Coding Sequence	VEP
Protein_position	Relative Position Of Amino Acid In Protein	VEP
Amino_acids	Only Given If The Variant Affects The Protein-Coding Sequence	VEP
Codons	The Alternative Codons With The Variant Base In Upper Case	VEP
Existing_variation	known Identifier Of Existing Variant Co-Located	VEP
DISTANCE	Shortest Distance From Variant To Transcript	VEP
STRAND	the Dna Strand (1 Or -1) On Which The Transcript/Feature Lies	VEP
FLAGS	Transcript Quality Flags:Cds_Start_Nf:cds 5' Incomplete; Cds_End_Nf:cds 3' Incomplete	VEP
VARIANT_CLASS	Sequence ontology (classes)	VEP
SYMBOL_SOURCE	The Source Of The Gene Symbol	VEP
HGNC_ID	A Unique Id Provided By The Hgnc For Each Gene With An Approved Symbol. Hgnc Ids Remain Stable Even If A Name Or Symbol Changes.	VEP
CANONICAL	A Flag Indicating If The Transcript Is Denoted As The Canonical Transcript For This Gene	VEP
MANE	Adds A Flag Indicating If The Transcript Is Themane Selecttranscript For The Gene.	VEP
TSL	transcript support levelfor this transcript to the output	VEP
CCDS	Ccds (Consensus Coding Sequence Set) Transcript Identifer	VEP
ENSP	Ensembl Protein Identifier	VEP
SWISSPROT	Best Match Accession For Translated Protein Products From Swissprot Database Ofuniprot	UniProt
TREMBL	Best Match Accession For Translated Protein Products From Trembl Database Ofuniprot	UniProt
UNIPARC	Best Match Accession For Translated Protein Products From Uniparc Database Ofuniprot	UniProt
SOURCE	Source Of Transcript	VEP
GENE_PHENO	Indicates If The Overlapped Gene Is Associated With A Phenotype, Disease Or Trait. https://Www.Ensembl.Org/Info/Genome/Variation/Phenotype/Sources_Phenotype_Documentation.html	VEP
SIFT	Predicts Whether An Amino Acid Substitution Affects Protein Function Based On Sequence Homology And The Physical Properties Of Amino Acids (Prediction)	VEP
PolyPhen	Predicts Possible Impact Of An Amino Acid Substitution On The Structure And Function Of A Human Protein Using Straightforward Physical And Comparative Considerations (Prediction)	VEP
DOMAINS	Names Of Overlapping Protein Domains	VEP
gnomAD_AF	Total Allele Frequency From Genome Aggregation Database(Gnomad V2.1 Exomes	VEP
gnomAD_AFR_AF	Allele Frequency Of Alternative Allele In Genome Aggregation Database(Gnomad V2.1) Exomes- African Population	VEP
gnomAD_AMR_AF	Allele Frequency Of Alternative Allele In Genome Aggregation Database(Gnomad V2.1) Exomes - American Population	VEP
gnomAD_ASJ_AF	Allele Frequency Of Alternative Allele In Genome Aggregation Database(Gnomad V2.1) Exomes - Ashkenazi Jewish Population	VEP
gnomAD_EAS_AF	Allele Frequency Of Alternative Allele In Genome Aggregation Database(Gnomad V2.1) Exomes - East Asian Population	VEP
gnomAD_FIN_AF	Allele Frequency Of Alternative Allele In Genome Aggregation Database(Gnomad V2.1) Exomes - Finnish Population	VEP
gnomAD_NFE_AF	Allele Frequency Of Alternative Allele In Genome Aggregation Database(Gnomad V2.1) Exomes - Non-Finnish Population	VEP
gnomAD_OTH_AF	Allele Frequency Of Alternative Allele In Genome Aggregation Database(Gnomad V2.1) Exomes - Other Population	VEP
gnomAD_SAS_AF	Allele Frequency Of Alternative Allele In Genome Aggregation Database(Gnomad V2.1) Exomes - South Asian Population	VEP
MAX_AF	The Highest Allele Frequency Observed In Any Population From 1000 Genomes, Esp Or Gnomad.	VEP
MAX_AF_POPS	Populations In Which Maximum Allele Frequency Was Observed	VEP
CLIN_SIG	Clinvar Clinical Significance Of The Dbsnp Variant	VEP_ClinVar (2019-12)
SOMATIC	Somatic Status Of Existing Variant(S); Multiple Values Correspond To Multiple Values In The Existing_Variation Field	VEP
PHENO	Indicates If Existing Variant Is Associated With A Phenotype, Disease Or Trait; Multiple Values Correspond To Multiple Values In The Existing_Variation Field	VEP
PUBMED	Pubmed Ids For Publications That Cite Existing Variant	VEP
MOTIF_NAME	The Source And Identifier Of A Transcription Factor Binding Profile Aligned At This Position	VEP
MOTIF_POS	The Relative Position Of The Variation In The Aligned Tfbp	VEP
HIGH_INF_POS	A Flag Indicating If The Variant Falls In A High Information Position Of A Transcription Factor Binding Profile (Tfbp)	VEP
MOTIF_SCORE_CHANGE	The Difference In Motif Score Of The Reference And Variant Sequences For The Tfbp	VEP
1000Gp3_AF	Global Allele Frequency (Af) From 1000 Genomes Phase 3 Data	dbNSFP_v4.1a
Aloft_Confidence	"Confidence Level Of Aloft_Pred; Values Can Be ""High Confidence"" (P < 0.05) Or ""Low Confidence"" (P > 0.05)"	dbNSFP_v4.1a
Aloft_pred	Final Classification Predicted By Aloft (Aloft Provides Extensive Annotations To Putative Loss-Of-Function Variants (Lof) In Protein-Coding Genes); Values Can Be Tolerant, Recessive Or Dominant	dbNSFP_v4.1a
BayesDel_addAF_pred	"Bayesdel Is A Deleteriousness Meta-Score. It Works For Coding And Non-Coding Variants, Single Nucleotide Variants And Small Insertion / Deletions. The Range Of The Score Is From -1.29334 To 0.75731. The Higher The Score, The More Likely The Variant Is Pathogenic (Prediction). The Score Cutoff Between ""D"" And ""T"" Is 0.0692655."	dbNSFP_v4.1a
CADD_phred	Combined Annotation Dependent Depletion (Cadd) Pathogenicity Prediction (Score). This Is Phred-Like Rank Score Based On Whole Genome Cadd Raw Scores. Please Refer To Kircher Et Al. (2014) Nature Genetics 46(3):310-5 For Details. The Larger The Score The More Likely The Snp Has Damaging Effect.	dbNSFP_v4.1a
ClinPred_pred	"Prediction Of Clinpred Score Based On The Authors' Recommendation, ""T(Olerated)"" Or ""D(Amaging)"". The Score Cutoff Between ""D"" And ""T"" Is 0.5."	dbNSFP_v4.1a
DANN_score	"Prediction Of Clinpred Score Based On The Authors' Recommendation, ""T(Olerated)"" Or ""D(Amaging)"". The Score Cutoff Between ""D"" And ""T"" Is 0.5."	dbNSFP_v4.1a
DEOGEN2_pred	"Prediction Of Deogen2 Score Based On The Authors' Recommendation, ""T(Olerated)"" Or ""D(Amaging)"". The Score Cutoff Between ""D"" And ""T"" Is 0.5."	dbNSFP_v4.1a
Eigen-phred_coding	Eigen Score In Phred Scale.	dbNSFP_v4.1a
FATHMM_pred	"If A Fathmmori Score Is <=-1.5 (Or Rankscore >=0.81332) The Corresponding Nssnv Is Predicted As ""D(Amaging)""; Otherwise It Is Predicted As ""T(Olerated)"". Multiple Predictions Separated By "";"", Corresponding To Ensembl_Proteinid."	dbNSFP_v4.1a
GERP++_RS	Gerp++ Rs Score, The Larger The Score, The More Conserved The Site. Scores Range From -12.3 To 6.17.	dbNSFP_v4.1a
GTEx_V8_gene	Target Gene Of The (Significant) Eqtl Snp	dbNSFP_v4.1a
GTEx_V8_tissue	Tissue Type Of The Expression Data With Which The Eqtl/Gene Pair Is Detected	dbNSFP_v4.1a
GenoCanyon_score	Functional Prediction Score Based On Conservation And Biochemical Annotations Using An Unsupervised Statistical Learning. (Doi:10.1038/Srep10576)	dbNSFP_v4.1a
Geuvadis_eQTL_target_gene	Ensembl Gene Id Of The Eqtl Associated With, From The Geuvadis Project	dbNSFP_v4.1a
Interpro_domain	"Domain Or Conserved Site On Which The Variant Locates. Domain Annotations Come From Interpro Database. The Number In The Brackets Following A Specific Domain Is The Count Of Times Interpro Assigns The Variant Position To That Domain, Typically Coming From Different Predicting Databases. Multiple Entries Separated By "";""."	dbNSFP_v4.1a
LRT_pred	Lrt Prediction, D(Eleterious), N(Eutral) Or U(Nknown), Which Is Not Solely Determined By The Score.	dbNSFP_v4.1a
M-CAP_pred	"Rediction Of M-Cap Score Based On The Authors' Recommendation, ""T(Olerated)"" Or ""D(Amaging)"". The Score Cutoff Between ""D"" And ""T"" Is 0.025."	dbNSFP_v4.1a
MetaLR_pred	"Prediction Of Our Metalr Based Ensemble Prediction Score,""T(Olerated)"" Or ""D(Amaging)"". The Score Cutoff Between ""D"" And ""T"" Is 0.5. The Rankscore Cutoff Between ""D"" And ""T"" Is 0.81101."	dbNSFP_v4.1a
MetaSVM_pred	"Prediction Of Our Svm Based Ensemble Prediction Score,""T(Olerated)"" Or ""D(Amaging)"". The Score Cutoff Between ""D"" And ""T"" Is 0. The Rankscore Cutoff Between ""D"" And ""T"" Is 0.82257."	dbNSFP_v4.1a
MutationAssessor_pred	"Mutationassessor's Functional Impact Of A Variant - Predicted Functional, I.E. High (""H"") Or Medium (""M""), Or Predicted Non-Functional, I.E. Low (""L"") Or Neutral (""N""). The Maori Score Cutoffs Between ""H"" And ""M"", ""M"" And ""L"", And ""L"" And ""N"", Are 3.5, 1.935 And 0.8, Respectively. The Rankscore Cutoffs Between ""H"" And ""M"", ""M"" And ""L"", And ""L"" And ""N"", Are 0.9307, 0.52043 And 0.19675, Respectively."	dbNSFP_v4.1a
MutationTaster_pred	"Mutationtaster Prediction, ""A"" (""Disease_Causing_Automatic""), ""D"" (""Disease_Causing""), ""N"" (""Polymorphism"") Or ""P"" (""Polymorphism_Automatic""). The Score Cutoff Between ""D"" And ""N"" Is 0.5 For Mtnew And 0.31733 For The Rankscore."	dbNSFP_v4.1a
PROVEAN_pred	"If Proveanori <= -2.5 (Rankscore>=0.54382) The Corresponding Nssnv Is Predicted As ""D(Amaging)""; Otherwise It Is Predicted As ""N(Eutral)"". Multiple Predictions Separated By "";"", Corresponding To Ensembl_Proteinid."	dbNSFP_v4.1a
Polyphen2_HDIV_pred	"Polyphen2 Prediction Based On Humdiv, ""D"" (""Probably Damaging"", Hdiv Score In [0.957,1] Or Rankscore In [0.55859,0.91137]), ""P"" (""Possibly Damaging"", Hdiv Score In [0.454,0.956] Or Rankscore In [0.37043,0.55681]) And ""B"" (""Benign"", Hdiv Score In [0,0.452] Or Rankscore In [0.03061,0.36974]). Score Cutoff For Binary Classification Is 0.5 For Hdiv Score Or 0.38028 For Rankscore, I.E. The Prediction Is ""Neutral"" If The Hdiv Score Is Smaller Than 0.5 (Rankscore Is Smaller Than 0.38028), And ""Deleterious"" If The Hdiv Score Is Larger Than 0.5 (Rankscore Is Larger Than 0.38028). Multiple Entries Are Separated By "";"", Corresponding To Uniprot_Acc."	dbNSFP_v4.1a
Polyphen2_HVAR_pred	"Polyphen2 Prediction Based On Humvar, ""D"" (""Probably Damaging"", Hvar Score In [0.909,1] Or Rankscore In [0.65694,0.97581]), ""P"" (""Possibly Damaging"", Hvar In [0.447,0.908] Or Rankscore In [0.47121,0.65622]) And ""B"" (""Benign"", Hvar Score In [0,0.446] Or Rankscore In [0.01493,0.47076]). Score Cutoff For Binary Classification Is 0.5 For Hvar Score Or 0.48762 For Rankscore, I.E. The Prediction Is ""Neutral"" If The Hvar Score Is Smaller Than 0.5 (Rankscore Is Smaller Than 0.48762), And ""Deleterious"" If The Hvar Score Is Larger Than 0.5 (Rankscore Is Larger Than 0.48762). Multiple Entries Are Separated By "";"", Corresponding To Uniprot_Acc."	dbNSFP_v4.1a
Reliability_index	Number Of Observed Component Scores (Except The Maximum Frequency In The 1000 Genomes Populations) For Metasvm And Metalr. Ranges From 1 To 10. As Metasvm And Metalr Scores Are Calculated Based On Imputed Data, The Less Missing Component Scores, The Higher The Reliability Of The Scores And Predictions.	dbNSFP_v4.1a
SIFT4G_pred	"If Sift4g Is < 0.05 The Corresponding Nssnv Is Predicted As ""D(Amaging)""; Otherwise It Is Predicted As ""T(Olerated)"". Multiple Scores Separated By "","", Corresponding To Ensembl_Transcriptid"	dbNSFP_v4.1a
SIFT_pred	"If Siftori Is Smaller Than 0.05 (Rankscore>0.39575) The Corresponding Nssnv Is Predicted As ""D(Amaging)""; Otherwise It Is Predicted As ""T(Olerated)"". Multiple Predictions Separated By "";"""	dbNSFP_v4.1a
clinvar_MedGen_id	Medgen Id Of The Trait/Disease The Clinvar_Trait Referring To	dbNSFP_v4.1a
clinvar_OMIM_id	Omim Id Of The Trait/Disease The Clinvar_Trait Referring To	dbNSFP_v4.1a
clinvar_Orphanet_id	Orphanet Id Of The Trait/Disease The Clinvar_Trait Referring To	dbNSFP_v4.1a
clinvar_clnsig	Clinical Significance By Clinvar Possible Values: Benign, Likely_Benign, Likely_Pathogenic, Pathogenic, Drug_Response, Histocompatibility. A Negative Score Means The Score Is For The Ref Allele	dbNSFP_v4.1a
clinvar_review	Clinvar Review Status Summary Possible Values: No Assertion Criteria Provided, Criteria Provided, Single Submitter, Criteria Provided, Multiple Submitters, No Conflicts, Reviewed By Expert Panel, Practice Guideline	dbNSFP_v4.1a
clinvar_trait	The Trait/Disease The Clinvar_Clnsig Referring To	dbNSFP_v4.1a
fathmm-MKL_coding_pred	"If A Fathmm-Mkl_Coding_Score Is >0.5 (Or Rankscore >0.28317) The Corresponding Nssnv Is Predicted As ""D(Amaging)""; Otherwise It Is Predicted As ""N(Eutral)""."	dbNSFP_v4.1a
fathmm-XF_coding_pred	"If A Fathmm-Xf_Coding_Score Is >0.5, The Corresponding Nssnv Is Predicted As ""D(Amaging)""; Otherwise It Is Predicted As ""N(Eutral)""."	dbNSFP_v4.1a
gnomAD_exomes_AC	Alternative Allele Count In The Whole Gnomad Exome Samples (125,748 Samples)	dbNSFP_v4.1a
gnomAD_exomes_AF	Alternative Allele Frequency In The Whole Gnomad Exome Samples (125,748 Samples)	dbNSFP_v4.1a
gnomAD_exomes_AN	Total Allele Count In The Whole Gnomad Exome Samples (125,748 Samples)	dbNSFP_v4.1a
gnomAD_exomes_NFE_AC	Alternative Allele Count In The Non-Finnish European Gnomad Exome Samples (56,885 Samples)	dbNSFP_v4.1a
gnomAD_exomes_NFE_AF	Alternative Allele Frequency In The Non-Finnish European Gnomad Exome Samples (56,885 Samples)	dbNSFP_v4.1a
gnomAD_exomes_NFE_AN	Total Allele Count In The Non-Finnish European Gnomad Exome Samples (56,885 Samples)	dbNSFP_v4.1a
gnomAD_exomes_NFE_nhomalt	Count Of Individuals With Homozygous Alternative Allele In The Non-Finnish European Gnomad Exome Samples (56,885 Samples)	dbNSFP_v4.1a
gnomAD_exomes_POPMAX_AC	Allele Count In The Population With The Maximum Af	dbNSFP_v4.1a
gnomAD_exomes_POPMAX_AF	Maximum Allele Frequency Across Populations (Excluding Samples Of Ashkenazi, Finnish, And Indeterminate Ancestry)	dbNSFP_v4.1a
gnomAD_exomes_POPMAX_AN	Total Number Of Alleles In The Population With The Maximum Af	dbNSFP_v4.1a
gnomAD_exomes_POPMAX_nhomalt	Count Of Homozygous Individuals In The Population With The Maximum Allele Frequency	dbNSFP_v4.1a
gnomAD_exomes_controls_AC	Alternative Allele Count In The Controls Subset Of Whole Gnomad Exome Samples (54,704 Samples)	dbNSFP_v4.1a
gnomAD_exomes_controls_AF	Alternative Allele Frequency In The Controls Subset Of Whole Gnomad Exome Samples (54,704 Samples)	dbNSFP_v4.1a
gnomAD_exomes_controls_AN	Total Allele Count In The Controls Subset Of Whole Gnomad Exome Samples (54,704 Samples)	dbNSFP_v4.1a
gnomAD_exomes_controls_nhomalt	Count Of Individuals With Homozygous Alternative Allele In The Controls Subset Of Whole Gnomad Exome Samples (54,704 Samples)	dbNSFP_v4.1a
gnomAD_exomes_nhomalt	Count Of Individuals With Homozygous Alternative Allele In The Whole Gnomad Exome Samples (125,748 Samples)	dbNSFP_v4.1a
gnomAD_genomes_AC	Alternative Allele Count In The Whole Gnomad Genome Samples (71,702 Samples)	dbNSFP_v4.1a
gnomAD_genomes_AF	Alternative Allele Frequency In The Whole Gnomad Genome Samples (71,702 Samples)	dbNSFP_v4.1a
gnomAD_genomes_AN	Total Allele Count In The Whole Gnomad Genome Samples (71,702 Samples)	dbNSFP_v4.1a
gnomAD_genomes_NFE_AC	Alternative Allele Count In The Non-Finnish European Gnomad Genome Samples (32,399 Samples)	dbNSFP_v4.1a
gnomAD_genomes_NFE_AF	Alternative Allele Frequency In The Non-Finnish European Gnomad Genome Samples (32,399 Samples)	dbNSFP_v4.1a
gnomAD_genomes_NFE_AN	Total Allele Count In The Non-Finnish European Gnomad Genome Samples (32,399 Samples)	dbNSFP_v4.1a
gnomAD_genomes_NFE_nhomalt	Count Of Individuals With Homozygous Alternative Allele In The Non-Finnish European Gnomad Genome Samples (32,399 Samples)	dbNSFP_v4.1a
gnomAD_genomes_nhomalt	Count Of Individuals With Homozygous Alternative Allele In The Whole Gnomad Genome Samples (71,702 Samples)	dbNSFP_v4.1a
ada_score	Ada Score	dbscSNV v1.1
rf_score	Random Forests Score Prediction For Splicing Consensus Regions (Scsnvs)	dbscSNV v1.1
SpliceAI_pred_DP_AG	Delta Position (Acceptor Gain)	SpliceAI v1.3
SpliceAI_pred_DP_AL	Delta Position (Acceptor Loss)	SpliceAI v1.3
SpliceAI_pred_DP_DG	Delta Position (Donor Gain)	SpliceAI v1.3
SpliceAI_pred_DP_DL	Delta Position (Donor Loss)	SpliceAI v1.3
SpliceAI_pred_DS_AG	Delta Score (Acceptor Gain). Ranges From 0 To 1. 0.2 (High Recall), 0.5 (Recommended), And 0.8 (High Precision) Cutoffs.	SpliceAI v1.3
SpliceAI_pred_DS_AL	Delta Score (Acceptor Loss). Ranges From 0 To 1. 0.2 (High Recall), 0.5 (Recommended), And 0.8 (High Precision)	SpliceAI v1.3
SpliceAI_pred_DS_DG	Delta Score (Donor Gain). Ranges From 0 To 1. 0.2 (High Recall), 0.5 (Recommended), And 0.8 (High Precision)	SpliceAI v1.3
SpliceAI_pred_DS_DL	Delta Score (Donor Loss). Ranges From 0 To 1. 0.2 (High Recall), 0.5 (Recommended), And 0.8 (High Precision)	SpliceAI v1.3
SpliceAI_pred_SYMBOL	Gene Symbol	SpliceAI v1.3
CADD_PHRED	Phred-Like Scaled Cadd Score	CADD_v1.6
CADD_RAW	Raw Cadd Score	CADD_v1.6
DisGeNET_PMID	Pmid Of The Publication Reporting The Variant-Disease Association	VEP_plugin
DisGeNET_SCORE	Disgenet Score For The Variant-Disease Association	VEP_plugin
DisGeNET_disease	Name Of The Disease Reporting The Variant-Pmid Association	VEP_plugin
gnomADlof_z	Gnomad Lof_Z Value For Gene	gnomad.v2.1.1
gnomADmis_z	Gnomad Mis_Z Value For Gene	gnomad.v2.1.1
gnomADoe_lof	##Gnomadoe_Lof=Gnomad Oe_Lof Value For Gene	gnomad.v2.1.1
gnomADoe_lof_upper	Gnomad Oe_Lof_Upper Value For Gene	gnomad.v2.1.1
gnomADoe_mis	Gnomad Oe_Mis Value For Gene	gnomad.v2.1.1
gnomADoe_mis_upper	Gnomad Oe_Mis_Upper Value For Gene	gnomad.v2.1.1
gnomADoe_syn	Gnomad Oe_Syn Value For Gene	gnomad.v2.1.1
gnomADoe_syn_upper	Gnomad Oe_Syn_Upper Value For Gene	gnomad.v2.1.1
gnomADpLI	Gnomad Pli Value For Gene	gnomad.v2.1.1
gnomADsyn_z	Gnomad Syn_Z Value For Gene	gnomad.v2.1.1
gnomADg	GnomADg identifier	gnomad v3.0
gnomADg_AF	Total Allele Frequency From Genome Aggregation Database(Gnomad V3.0)	gnomad v3.0
gnomADg_AF_afr	Allele Frequency Of Alternative Allele In Genome Aggregation Database  African Population	gnomad v3.0
gnomADg_AF_amr	Allele Frequency Of Alternative Allele In Genome Aggregation Database - American Population	gnomad v3.0
gnomADg_AF_asj	Allele Frequency Of Alternative Allele In Genome Aggregation Database- Ashkenazi Jewish Population	gnomad v3.0
gnomADg_AF_eas	Allele Frequency Of Alternative Allele In Genome Aggregation Database - East Asian Population	gnomad v3.0
gnomADg_AF_fin	Allele Frequency Of Alternative Allele In Genome Aggregation Database- Finnish Population	gnomad v3.0
gnomADg_AF_nfe	Allele Frequency Of Alternative Allele In Genome Aggregation Database- Non-Finnish Population	gnomad v3.0
gnomADg_AF_oth	Allele Frequency Of Alternative Allele In Genome Aggregation Database- Other Population	gnomad v3.0
