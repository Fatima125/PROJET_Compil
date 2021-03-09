%{
#include "synt.tab.h"
extern nb_ligne;
extern YYSTYPE yylval;
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
Entier return mc_entier;
Reel return mc_reel;
Chaine return mc_chaine;
{idf} {  yylval.str=strdup(yytext);
         if(yyleng<=25) return idf;
         else printf("erreur lexical : idf trop long : %s",yytext);
      }
{idf_tab} return idf_tab;
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
