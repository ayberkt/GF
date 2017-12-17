concrete VerbTur of Verb = CatTur ** open ResTur in {

  lin
    UseV v = v ;
    SlashV2a v = v ;

    ComplSlash vps np = {
      s = \\ vf => vps.c.s ++ np.s ! vps.c.c ++ vps.s ! vf ;
    } ;

    AdVVP adv vp = {
      s = \\f => adv.s ++ vp.s ! f
    } ;

    AdvVP vp adv = {
      s = \\f => adv.s ++ vp.s ! f
    } ;

    UseComp comp = {s = \\_ => comp.s} ;

}
