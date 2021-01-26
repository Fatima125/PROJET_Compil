%token mc_import pvg bib_io bib_lang err mc_public mc_private mc_protected mc_class idf aco_ov aco_fr mc_entier mc_reel mc_chaine vrg idf_tab 
       cr_ov cr_fr cst mc_const mc_aff  plus moins mc_lettres mc_cst_chaine mc_cst_entier
%%
S:LISTE_BIB HEADER_CLASS aco_ov CORPS aco_fr {printf("pgm syntaxiquement correcte");
                            YYACCEPT}
;
HEADER_CLASS:MODIFICATEUR mc_class idf
;
MODIFICATEUR:mc_public
             |mc_private
             |mc_protected
             ;
CORPS:LISTE_DEC
;
LISTE_DEC:DEC LISTE_DEC
          |
;
DEC:DEC_VAR
    |DEC_TAB
    |DEC_CONST
;
DEC_CONST:DEC_AC_AFF
         |DEC_SANS_AFF           
;
DEC_AC_AFF: mc_const TYPE idf pvg
;
DEC_SANS_AFF: mc_const TYPE idf mc_aff Valeur pvg
;
Valeur: mc_cst_chaine
        |mc_cst_entier
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
