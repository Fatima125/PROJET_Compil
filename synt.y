
%{
nb_ligne=1;
char sauvType[20];
%}
%union{
       int entier;
       char* str;
       float reel;
}
%token mc_import pvg bib_io bib_lang err mc_public mc_private mc_protected mc_class <str>idf aco_ov aco_fr <str>mc_entier <str>mc_reel <str>mc_chaine vrg <str>idf_tab 
       cr_ov cr_fr <entier>cst mc_const mc_aff  plus moins mc_lettres mc_main par_ov par_fr mc_div mc_inf mc_for mc_in mc_format cot mc_chaine_car mc_out mc_commentaire multiplication
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
CORPS:mc_commentaire LISTE_DEC  MAIN
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
      |ECRITURE
;
AFFECTATION: AFF  AFFECTATION 
            |
;
AFF:idf mc_aff cst pvg {if(Declaration($1)==0)
                           printf("erreur semantique %s non declarer a la ligne %d\n",$1,nb_ligne);  
                        }
   |idf mc_aff idf mc_div cst pvg { if($5==0)
                                      printf("erreur semantique a la ligne %d division par 0\n",nb_ligne);
                                   }
   |idf mc_aff idf plus idf pvg
   |idf_tab cr_ov cst cr_fr mc_aff idf plus idf mc_div cst pvg
;
OPERATION:plus
         |moins
         |mc_div
         |multiplication
;
BOUCLE:BCL BOUCLE
       |
;
BCL:mc_for par_ov idf mc_aff cst pvg idf mc_inf cst pvg idf plus plus par_fr aco_ov aco_fr
;
LECTURE:LECT LECTURE
        |
;
LECT:mc_in par_ov mc_format vrg idf par_fr pvg 
;
ECRITURE:ECRIT ECRITURE
         |
;
ECRIT:mc_out par_ov mc_chaine_car par_fr pvg
;
DEC_CONST:DEC_AC_AFF
         |DEC_SANS_AFF           
;
DEC_SANS_AFF: mc_const TYPE idf pvg
;
DEC_AC_AFF: mc_const TYPE idf mc_aff cst pvg
;
DEC_TAB: TYPE LISTE_IDF_TAB pvg
;
LISTE_IDF_TAB:idf_tab cr_ov cst cr_fr vrg LISTE_IDF_TAB {if($3<0)
                                         printf("erreur semantique la taille du tableau %s doit etre positive , a la ligne %d\n",$1,nb_ligne);
                                       }
              |idf_tab cr_ov cst cr_fr {if($3<0)
                                         printf("erreur semantique la taille du tableau %s doit etre positive , a la ligne %d\n",$1,nb_ligne);
                                       }
;
DEC_VAR: TYPE LISTE_IDF pvg
;
LISTE_IDF:idf vrg LISTE_IDF { if(Declaration($1)==0)
                                    insererTYPE($1,sauvType);
                              else
                                    printf("erreur semantique double declaration %s a la ligne %d\n",$1,nb_ligne);      }
          |idf { if(Declaration($1)==0)
                                    insererTYPE($1,sauvType);
                              else
                                    printf("erreur semantique double declaration %s a la ligne %d\n",$1,nb_ligne);      }
;
TYPE:mc_entier {strcpy(sauvType,$1);}
    |mc_reel   {strcpy(sauvType,$1);}
    |mc_chaine {strcpy(sauvType,$1);}
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
    afficher();
}
yywrap() {}
yyerror(char * msg)
{
       printf("erreur syntaxique à la ligne %d\n",nb_ligne);
}
