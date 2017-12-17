concrete VerbTur of Verb = CatTur ** open ResTur in {

  lin
    UseV v = v ;
    SlashV2a v = v ;

    ComplSlash vps np = {
      s = \\ vf => vps.c.s ++ np.s ! vps.c.c ++ vps.s ! vf ;
    } ;

    -- TODO: The case should always be `Nom` but where should the number come
    -- from?  It doesn't make much sense when this is being linearized from
    -- `UseComp\` which doesn't have access to a sensible number parameter. 
    -- For now this should work well enough.
    CompAP ap = {
      s = ap.s ! Sg ! Nom
    } ;

    AdVVP adv vp = {
      s = \\f => adv.s ++ vp.s ! f
    } ;

    AdvVP vp adv = {
      s = \\f => adv.s ++ vp.s ! f
    } ;

    UseComp comp = {s = \\_ => comp.s} ;

}
