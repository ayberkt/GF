--# -path=.:../abstract:../common:../../prelude

concrete StructuralTur of Structural = CatTur **
  open ResTur, ParadigmsTur, Prelude in {

  flags
    optimize=all ; coding = utf8 ;

  lin
    he_Pron =
      mkPron "o" "onu" "ona" "onun" "onda" "ondan" "onlu" "onsuz" Sg P3 ;

    i_Pron  =
      mkPron "ben" "beni" "bana" "benim"
             "bende" "benden" "benli" "bensiz"
             Sg P1 ;

    it_Pron =
      mkPron "o" "onu" "ona" "onun" "onda" "ondan" "onlu" "onsuz" Sg P3 ;

    she_Pron =
      mkPron "o" "onu" "ona" "onun" "onda" "ondan" "onlu" "onsuz" Sg P3 ;

    that_Quant =
      mkQuant "o" ;

    they_Pron =
      mkPron "onlar" "onları" "onlara" "onların" "onlarda" "onlardan" "onlarlı"
             "onlarsız" Pl P3 ;

    this_Quant =
      mkQuant "bu" ;

    no_Quant =
      mkQuant "hiç" ;

    we_Pron =
      mkPron "biz" "bizi" "bize" "bizim" "bizde" "bizden" "bizli" "bizsiz" Pl P1 ;

    youSg_Pron =
      mkPron "sen" "seni" "sana" "senin" "sende" "senden" "senli" "sensiz" Sg P2 ;

    youPl_Pron =
      mkPron "siz" "sizi" "size" "sizin" "sizde" "sizden" "sizli" "sizsiz" Pl P2 ;

    youPol_Pron =
      mkPron "siz" "sizi" "size" "sizin" "sizde" "sizden" "sizli" "sizsiz" Pl P2 ;

    with_Prep =
      mkPrep [] (Abess Pos) ;

    -- ...den sonra
    after_Prep =
      mkPrep "sonra" Ablat ;

    -- ...den önce
    before_Prep =
      mkPrep "önce" Ablat ;

    -- ...nin üzerinde
    above_Prep =
      mkPrep "üzerinde" Gen ;

    -- ..nin arkasında
    behind_Prep =
      mkPrep "arkasında" Gen ;

    -- ...nin üzerinde
    -- ...nin üstünde
    on_Prep =
      variants {mkPrep "üzerinde" Gen; mkPrep "üstünde" Gen} ;

    in_Prep =
      variants {mkPrep "içinde" Gen; mkPrep "içerisinde" Gen} ;

    except_Prep = mkPrep "dışında" Nom | mkPrep "dışında" Gen ;

    -- ... sırasında
    during_Prep =
      mkPrep "sırasında" Nom ;

    -- ... ile ...nin arasında
    between_Prep =
      mkPrep "arasındaki" Gen ;

    and_Conj = mkConj "ile" ;

    or_Conj = mkConj "veya" ;

    yes_Utt = ss "evet" ;
    no_Utt  = ss "hayır" ;

    always_AdV = {s = "her zaman"} ;

    but_PConj = ss "ama" ;
    therefore_PConj = ss "dolayısıyla" ;

    everybody_NP  = mkNP (mkN "herkes")     Sg P3 ;
    everything_NP = mkNP (mkN "herşey")     Sg P3 ;
    nothing_NP    = mkNP (mkN "hiçbir şey") Sg P3 ;
    somebody_NP   = mkNP (mkN "biri")       Sg P3 ;
    something_NP  = mkNP (mkN "bir şey")    Sg P3 ;

    -- The sentence (PredVP (UsePron he_Pron) (UseV sing_V)) would be
    -- linearized as
    --   > nobody sings
    -- in English, whereas in Turkish it would literally translate to
    --   > nobody doesn't sing
    -- Linearizing (PredVP (UsePron he_Pron) (UseV sing_V)) will yield
    -- nobody sings regardless. The double negation will be implemented
    -- when `UseCl` is implemented eventually.
    nobody_NP      = mkNP (mkN "hiç kimse") Sg P3 ;

    many_Det       = mkDet "birçok" Sg NoGen ;
    every_Det      = mkDet "her"    Sg NoGen ;
    all_Predet     = {s = "her"} ;
    almost_AdA     = {s = "neredeyse"} ;
    almost_AdN     = {s = "neredeyse"} ;

    by8agent_Prep  = mkPrep "tarafından" Gen ;
    by8means_Prep  = mkPrep "tarafından" Gen ;

    although_Subj  = {s = "buna rağmen"} ;

    that_Subj = {s = "o"} ;

    -- TODO: this does not straightforwardly translate to Turkish which does
    -- not have a "when" as a subordinating conjunction.
    when_Subj = {s = "[TODO]"} ;

    because_Subj   = {s = "çünkü"} ;

    here_Adv       = mkAdv "burada" ;

    everywhere_Adv = mkAdv "her yerde" ;

    if_Subj        = {s = "eğer"} ;

    both7and_DConj  = mkConj "hem" "hem de" ;
    either7or_DConj = mkConj "ya"  "ya da"  ;

    few_Det = mkDet "birkaç" Sg NoGen ;

    for_Prep = mkPrep "için" Nom ;

    under_Prep = mkPrep "altında" Gen ;

    to_Prep   = mkPrep "" Dat ;
    from_Prep = mkPrep "" Ablat ;

    -- TODO: this is probably not correct. There is no straightforward
    -- translation for `possess_Prep` in Turkish.
    possess_Prep = mkPrep "" Gen ;

    -- There are four senses of "through" as a preposition in English:
    --
    --   1. from one side of an opening to the other ("go through the window"),
    --   2. entering, then later leaving ("drive through the town"),
    --   3. by means of ("win through intimidation"), and
    --   4. to or up to ("1945 to 1991").
    --
    -- All four of these would be translated in a different way to Turkish
    -- so I don't know what's the best way to implement `through_Prep`. The
    -- best thing to do is to just probably implement the most common use.
    -- TODO: implement linearization for through_Prep.

    -- TODO: there is really no have_V2 in Turkish.
    -- have_V2

    -- This is really just `here_Adv` in ablative form.
    here7from_Adv = mkAdv "buradan" ;

    -- This is really just `here_Adv` in dative form.
    here7to_Adv = mkAdv "buraya" ;

    somewhere_Adv = mkAdv "bir yere" ;
    there_Adv     = mkAdv "oraya" ;

    how8many_IDet = {s = "kaç tane"} ;

    how8much_IAdv = {s = "ne kadar"} ;

    how_IAdv = {s = "nasıl"} ;

    -- Conditionals in Turkish are handled through inflections.
    -- I will decide what to do with this later.
    if_then_Conj = mkConj "" "" ;

    -- TODO: in8front_Prep
    in8front_Prep = mkPrep "önünde" Gen ;

    language_title_Utt = {s = "Türkçe"} ;

    more_CAdv = {s = "daha"; p = "daha"} ;

    most_Predet = {s = "en çok"} ;

    much_Det = mkDet "çok" Pl NoGen ;

    without_Prep = mkPrep "" (Abess Neg) ;

    please_Voc = {s = "lütfen"} ;

    very_AdA = {s = "çok"} ;

    why_IAdv   = {s = "neden"} ;
    where_IAdv = {s = "nerede"} ;

    can8know_VV = {
      s = "(TODO: can8know_VV)"
    } ;

    can_VV = {
      s = "(TODO: can_VV)"
    } ;

    must_VV = {
      s = "(TODO: must_VV)"
    } ;


    quite_Adv = {
      s = "bayağı"
    } ;

}
