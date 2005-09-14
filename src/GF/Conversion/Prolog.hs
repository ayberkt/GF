----------------------------------------------------------------------
-- |
-- Maintainer  : PL
-- Stability   : (stable)
-- Portability : (portable)
--
-- > CVS $Date: 2005/09/14 09:51:18 $ 
-- > CVS $Author: peb $
-- > CVS $Revision: 1.4 $
--
-- Converting/Printing different grammar formalisms in Prolog-readable format
-----------------------------------------------------------------------------


module GF.Conversion.Prolog (prtSGrammar, prtSMulti, prtSHeader, prtSRule,
                             prtMGrammar, prtMMulti, prtMHeader, prtMRule,
                             prtCGrammar, prtCMulti, prtCHeader, prtCRule) where

import GF.Formalism.GCFG
import GF.Formalism.SimpleGFC
import GF.Formalism.MCFG
import GF.Formalism.CFG
import GF.Formalism.Utilities
import GF.Conversion.Types
import qualified GF.Conversion.GFC as Cnv

import GF.Data.Operations ((++++), (+++++))
import GF.Infra.Print
import qualified GF.Infra.Modules as Mod
import qualified GF.Infra.Option as Option
import GF.Data.Operations (okError)
import GF.Canon.AbsGFC (Flag(..))
import GF.Canon.GFC (CanonGrammar)
import GF.Infra.Ident (Ident(..))

import Data.Maybe (maybeToList, listToMaybe)
import Data.Char (isLower, isAlphaNum)

----------------------------------------------------------------------
-- | printing multiple languages at the same time

prtSMulti, prtMMulti, prtCMulti :: Option.Options -> CanonGrammar -> String
prtSMulti = prtMulti prtSHeader prtSRule Cnv.gfc2simple "gfc_"
prtMMulti = prtMulti prtMHeader prtMRule Cnv.gfc2mcfg "mcfg_"
prtCMulti = prtMulti prtCHeader prtCRule Cnv.gfc2cfg "cfg_"

-- code and ideas stolen from GF.CFGM.PrintCFGrammar

prtMulti prtHeader prtRule conversion prefix opts gr
    = prtHeader ++++ unlines
      [ "\n\n" ++ prtLine ++++
        "%% Language module: " ++ prtQ langmod +++++
        unlines (map (prtRule langmod) rules) |
        lang <- maybe [] (Mod.allConcretes gr) (Mod.greatestAbstract gr),
        let Mod.ModMod (Mod.Module{Mod.flags=fs}) = okError (Mod.lookupModule gr lang),
        let cnvopts = Option.Opts $ map Option.gfcConversion $ getFlag fs "conversion",
        let rules = conversion cnvopts (gr, lang),
        let langmod = (let IC lg = lang in prefix ++ lg) ]

getFlag :: [Flag] -> String -> [String]
getFlag fs x = [v | Flg (IC k) (IC v) <- fs, k == x]

----------------------------------------------------------------------
-- | SimpleGFC to Prolog
--
-- assumes that the profiles in the Simple GFC names are trivial
prtSGrammar :: SGrammar -> String
prtSGrammar rules = prtSHeader +++++ unlines (map (prtSRule "") rules)

prtSHeader :: String
prtSHeader = prtLine ++++
             "%% Simple GFC grammar in Prolog-readable format" ++++
             "%% Autogenerated from the Grammatical Framework" +++++
             "%% The following predicate is defined:" ++++
             "%% \t rule(Fun, Cat, c(Cat,...), LinTerm)"

prtSRule :: String -> SRule -> String
prtSRule lang (Rule (Abs cat cats (Name fun _prof)) (Cnc _ _ mterm)) 
    = (if null lang then "" else prtQ lang ++ " : ") ++ 
      prtFunctor "rule" [plfun, plcat, plcats, plcnc] ++ "."
    where plfun  = prtQ fun
          plcat  = prtSCat cat
          plcats = prtFunctor "c" (map prtSCat cats) 
	  plcnc  = "\n\t" ++ prtSTerm (maybe Empty id mterm)

prtSTerm (Arg n c p)    = prtFunctor "arg" [prtQ c, prt (n+1), prtSPath p]
-- prtSTerm (c :^ [])   = prtQ c
prtSTerm (c :^ ts)      = prtOper "^" (prtQ c) (prtPList (map prtSTerm ts))
prtSTerm (Rec rec)      = prtFunctor "rec" [prtPList [ prtOper "=" (prtQ l) (prtSTerm t) | (l, t) <- rec ]]
prtSTerm (Tbl tbl)      = prtFunctor "tbl" [prtPList [ prtOper "=" (prtSTerm p) (prtSTerm t) | (p, t) <- tbl ]]
prtSTerm (Variants ts)  = prtFunctor "variants" [prtPList (map prtSTerm ts)]
prtSTerm (t1 :++ t2)    = prtOper "+" (prtSTerm t1) (prtSTerm t2)
prtSTerm (Token t)      = prtFunctor "tok" [prtQ t]
prtSTerm (Empty)        = "empty"
prtSTerm (term :. lbl)  = prtOper "*" (prtSTerm term) (prtQ lbl)
prtSTerm (term :! sel)  = prtOper "/" (prtSTerm term) (prtSTerm sel)
-- prtSTerm (Wildcard)  = "wildcard"
-- prtSTerm (Var var)   = prtFunctor "var" [prtQ var]

prtSPath (Path path) = prtPList (map (either prtQ prtSTerm) path)

prtSCat (Decl var cat args)     = prVar ++ prtFunctor (prtQ cat) (map prtSTTerm args)
    where prVar | var == anyVar = ""
                | otherwise     = "_" ++ prt var ++ ":"

prtSTTerm (con :@ args) = prtFunctor (prtQ con) (map prtSTTerm args)
prtSTTerm (TVar var)    = "_" ++ prt var

----------------------------------------------------------------------
-- | MCFG to Prolog
prtMGrammar :: MGrammar -> String
prtMGrammar rules = prtMHeader +++++ unlines (map (prtMRule "") rules)

prtMHeader :: String
prtMHeader = prtLine ++++
             "%% Multiple context-free grammar in Prolog-readable format" ++++
             "%% Autogenerated from the Grammatical Framework" +++++
             "%% The following predicate is defined:" ++++
             "%% \t rule(Profile, Cat, c(Cat,...), [Lbl=Symbols,...])" 

prtMRule :: String -> MRule -> String
prtMRule lang (Rule (Abs cat cats name) (Cnc _lcat _lcats lins)) 
    = (if null lang then "" else prtQ lang ++ " : ") ++ 
      prtFunctor "rule" [plname, plcat, plcats, pllins] ++ "."
    where plname = prtName name
          plcat  = prtQ cat
          plcats = prtFunctor "c" (map prtQ cats) 
          pllins = "\n\t[ " ++ prtSep "\n\t, " (map prtMLin lins) ++ " ]"

prtMLin (Lin lbl lin) = prtOper "=" (prtQ lbl) (prtPList (map prtMSymbol lin))

prtMSymbol (Cat (cat, lbl, nr)) = prtFunctor "arg" [prtQ cat, show (nr+1), prtQ lbl]
prtMSymbol (Tok tok) = prtFunctor "tok" [prtQ tok]

----------------------------------------------------------------------
-- | CFG to Prolog
prtCGrammar :: CGrammar -> String
prtCGrammar rules = prtCHeader +++++ unlines (map (prtCRule "") rules)

prtCHeader :: String
prtCHeader = prtLine ++++
             "%% Context-free grammar in Prolog-readable format" ++++
             "%% Autogenerated from the Grammatical Framework" +++++
             "%% The following predicate is defined:" ++++
             "%% \t rule(Profile, Cat, [Symbol,...])"

prtCRule :: String -> CRule -> String
prtCRule lang (CFRule cat syms name)
    = (if null lang then "" else prtQ lang ++ " : ") ++ 
      prtFunctor "cfgrule" [plname, plcat, plsyms] ++ "."
    where plname = prtName name
          plcat  = prtQ cat
          plsyms = prtPList (map prtCSymbol syms) 

prtCSymbol (Cat cat) = prtFunctor "cat" [prtQ cat]
prtCSymbol (Tok tok) = prtFunctor "tok" [prtQ tok]

----------------------------------------------------------------------
-- profiles, quoted strings and more

prtFunctor f xs = f ++ if null xs then "" else "(" ++ prtSep ", " xs ++ ")"
prtPList     xs = "[" ++ prtSep ", " xs ++ "]"
prtOper   f x y = "(" ++ x ++ " " ++ f ++ " " ++ y ++ ")"

prtName name@(Name fun profiles)
    | name == coercionName = "1"
    | and (zipWith (==) profiles (map (Unify . return) [0..])) = prtQ fun
    | otherwise = prtFunctor (prtQ fun) (map prtProfile profiles) 

prtProfile (Unify []) = " ? "
prtProfile (Unify args) = foldr1 (prtOper "=") (map (show . succ) args)
prtProfile (Constant forest) = prtForest forest

prtForest (FMeta) = " ? "
prtForest (FNode fun [fs]) = prtFunctor (prtQ fun) (prtPList (map prtForest fs))
prtForest (FNode fun fss) = prtPList [ prtFunctor (prtQ fun) (prtPList (map prtForest fs)) |
                                       fs <- fss ]

prtQ atom = prtQStr (prt atom)

prtQStr atom@(x:xs) 
    | isLower x && all isAlphaNumUnder xs = atom
    where isAlphaNumUnder '_' = True
          isAlphaNumUnder x = isAlphaNum x
prtQStr atom =  "'" ++ concatMap esc (prt atom) ++ "'"
    where esc '\'' = "\\'"
          esc '\n' = "\\n"
          esc '\t' = "\\t"
          esc c = [c]

prtLine = replicate 70 '%'


