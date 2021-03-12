%{
#include "synt.tab.h"
extern nb_ligne;
extern YYSTYPE yylval;

//je vais commencer a programmer ma tables des symboles
//declaration (structure de la table des symboles)
       typedef struct
       {
             char NomEntite[20];
             char CodeEntite[20];
             char TypeEntite[20];
             char Constante[20];
             char Valeur[20];
       }TypeTS;
  //initialisation d'un tableau
       TypeTS ts[100];
  //un compteur global pour la table des symboles
       int CpTabSym=0;
   //définir une fonction recherche
       int recherche(char entite[])
       {
             int i=0;
             while(i<CpTabSym)
             {
                   if(strcmp(entite,ts[i].NomEntite)==0) return i;
                   i++;
             }
             return -1;
       }
  //définir la fonction inserer
        void inserer(char entite[],char code[])
        {
              if(recherche(entite)==-1)
              {
                    strcpy(ts[CpTabSym].NomEntite,entite);
                    strcpy(ts[CpTabSym].CodeEntite,code);
                    strcpy(ts[CpTabSym].Constante,"non");
                    CpTabSym++;
              }
        }
   //définir la fonction pour inserer le type
        void insererTYPE(char entite[],char type[])
        {
            int pos;
            pos=recherche(entite);
              if(pos!=-1)
              {
                    strcpy(ts[pos].TypeEntite,type);
              }
        }
  //définir la fonction afficher
        void afficher()
        {
              printf("\n/**************Table des symboles*******************/\n");
              printf("__________________________________________________________________________________________\n");
              printf("\t| NomEntite |  CodeEntite  | TypeEntite   | Constante    | Valeur \n");
              printf("___________________________________________________________________________________________\n");
              int i=0;
              while(i<CpTabSym)
              {
                    printf("\t|%10s |%12s  | %12s | %12s | %12s \n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite,ts[i].Constante,ts[i].Valeur);
                    i++;
              }
        } 
        //définir une fonction qui détecte la double déclaration
        int Declaration (char entite[])
        {
              int pos;
              pos=recherche(entite);
              if(strcmp(ts[pos].TypeEntite,"")==0)
                 return 0;
               else return -1;  
        }
%}
lettres [a-zA-Z]
chiffres ([+-]?[1-9][0-9]*)|0
idf "$"{lettres}({lettres}|{chiffres}|_)*
idf_tab "@"{lettres}({lettres}|{chiffres}|_)*
chaine_car [^\"]
commentaire .|\n
format %d|%f|%s


%%
import return mc_import;
ISIL.io return bib_io;
ISIL.lang return bib_lang;
public return mc_public;
private return mc_private;
protected return mc_protected;
class return mc_class;
Entier { yylval.str=strdup("Entier");
         return mc_entier;}
Reel { yylval.str=strdup("Reel");
       return mc_reel;}
Chaine {yylval.str=strdup("Chaine");
        return mc_chaine;}
{idf} {  if(yyleng<=25){ inserer(yytext,"idf");
                         yylval.str=strdup(yytext);
                         return idf;}
         else printf("erreur lexical : idf trop long : %s",yytext);
      }
{idf_tab} { yylval.str=strdup(yytext);
            return idf_tab;}
{chiffres} {  yylval.entier=atoi(yytext);
              return cst; }
{lettres} return mc_lettres;
"[" return cr_ov;
"]" return cr_fr;
"," return vrg;
"{" return aco_ov;
"}" return aco_fr;
; return pvg;
"+" return plus;
"-" return moins;
"*" return multiplication;
main return mc_main;
"(" return par_ov;
")" return par_fr;
"/" return mc_div;
CONST return mc_const;
:= return mc_aff;
For return mc_for;
"<" return mc_inf;
In return mc_in;
[\"]{format}[\"] return mc_format;
##{commentaire}*## return mc_commentaire;
\" return cot;
[\"]{chaine_car}*[\"] return mc_chaine_car;
Out return mc_out;
[ \t]
\n nb_ligne++;
. {printf("erreur lexicale a la ligne %d sur l'entite %s\n",nb_ligne,yytext);
   return err;}
