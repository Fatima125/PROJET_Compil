%token mc_import pvg bib_io bib_lang err mc_public mc_private mc_protected mc_class idf aco_ov aco_fr mc_entier mc_reel mc_chaine vrg idf_tab 
       cr_ov cr_fr cst mc_const mc_aff  plus moins mc_lettres mc_main par_ov par_fr mc_div mc_inf mc_for mc_in mc_format cot
%%
S:LISTE_BIB HEADER_CLASS aco_ov CORPS  aco_fr {printf("pgm syntaxiquement correcte");
                            YYACCEPT}
;
HEADER_CLASS:MODIFICATEUR mc_class idf
;
MODIFICATEUR:mc_public
             |mc_private
             |mc_protected
             ;
CORPS:LISTE_DEC  MAIN
;
LISTE_DEC:DEC LISTE_DEC
          |
;
DEC:DEC_VAR
    |DEC_TAB
    |DEC_CONST
;
MAIN:mc_main par_ov par_fr aco_ov INSTRUCTION aco_fr
;
INSTRUCTION:INST INSTRUCTION    
            |
;
INST:AFFECTATION 
      |BOUCLE
      |LECTURE
;
AFFECTATION: AFF  AFFECTATION 
            |
;
AFF:idf mc_aff cst pvg
   |idf mc_aff idf plus idf pvg
   |idf_tab cr_ov cst cr_fr mc_aff idf plus idf mc_div cst pvg
;
BOUCLE:BCL BOUCLE
       |
;
BCL:mc_for par_ov idf mc_aff cst pvg idf mc_inf cst pvg idf plus plus par_fr aco_ov aco_fr
;
LECTURE:LECT LECTURE
        |
;
LECT:mc_in par_ov cot mc_format cot vrg idf par_fr pvg 
;
DEC_CONST:DEC_AC_AFF
         |DEC_SANS_AFF           
;
DEC_AC_AFF: mc_const TYPE idf pvg
;
DEC_SANS_AFF: mc_const TYPE idf mc_aff Valeur pvg
;
Valeur: cst
       |mc_lettres
;
signe : plus
       |moins
;
DEC_TAB: TYPE LISTE_IDF_TAB pvg
;
LISTE_IDF_TAB:idf_tab cr_ov cst cr_fr vrg LISTE_IDF_TAB
              |idf_tab cr_ov cst cr_fr
;
DEC_VAR: TYPE LISTE_IDF pvg
;
LISTE_IDF:idf vrg LISTE_IDF
          |idf 
;
TYPE: mc_entier
      |mc_reel
       |mc_chaine
;
LISTE_BIB: BIB LISTE_BIB
        |
;
BIB:mc_import NOM_BIB pvg 
;
NOM_BIB:bib_io|bib_lang
;
%%
main()
{
    yyparse();
}
yywrap() {}
