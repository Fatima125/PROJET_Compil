%{
#include "synt.tab.h"
extern nb_ligne;
%}
lettres [a-zA-Z]
chiffres [0-9]
idf "$"{lettres}({lettres}|{chiffres}|_)*
idf_tab "@"{lettres}({lettres}|{chiffres}|_)*


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
{idf} { if(yyleng<=25) return idf;
      else printf("erreur lexical : idf trop long : %s",yytext);
      }
{idf_tab} return idf_tab;
{chiffres} return cst;
{lettres} return mc_lettres;
"[" return cr_ov;
"]" return cr_fr;
"," return vrg;
"{" return aco_ov;
"}" return aco_fr;
; return pvg;
"+" return plus;
"-" return moins;
main return mc_main;
"(" return par_ov;
")" return par_fr;
"/" return mc_div;
CONST return mc_const;
:= return mc_aff;
For return mc_for;
"<" return mc_inf;
In return mc_in;
%d return mc_format;
\" return cot;
[ \t]
\n nb_ligne++;
. {printf("erreur lexicale a la ligne %d sur l'entite %s\n",nb_ligne,yytext);
   return err;}
