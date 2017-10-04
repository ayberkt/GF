concrete ConjunctionTur of Conjunction =
  CatTur ** open ResTur, Coordination, Prelude in {
    lincat
      ListNP = {s : Str} ;

    lin
      BaseNP x y = {s = x.s ! Nom ++ y.s ! Nom} ;
      ConsNP x xs = {s = x.s ! Nom ++ BIND ++ "," ++ xs.s} ;
  }
