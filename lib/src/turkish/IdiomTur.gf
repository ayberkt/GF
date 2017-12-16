concrete IdiomTur of Idiom =
  CatTur ** open Prelude, ResTur, ParadigmsTur, HarmonyTur in {

  lin

    -- TODO: overlad `mkN` to take in an agreement so that "kendi"
    -- will linearize here as "kendisi".
    SelfNP np = {
      s =
        let
          kendi : N = mkN "kendi"
        in
          \\c => np.s ! Gen ++ kendi.s ! np.a.n ! c ;
      a = np.a
    } ;

}

