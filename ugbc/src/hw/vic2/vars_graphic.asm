; ------------------------------------------------------------------------------
; BITMAP MODE (MODE #2)
; ------------------------------------------------------------------------------

PLOTVBASELO:
    .byte <($A000+(0*320)),<($A000+(1*320)),<($A000+(2*320)),<($A000+(3*320))
    .byte <($A000+(4*320)),<($A000+(5*320)),<($A000+(6*320)),<($A000+(7*320))
    .byte <($A000+(8*320)),<($A000+(9*320)),<($A000+(10*320)),<($A000+(11*320))
    .byte <($A000+(12*320)),<($A000+(13*320)),<($A000+(14*320)),<($A000+(15*320))
    .byte <($A000+(16*320)),<($A000+(17*320)),<($A000+(18*320)),<($A000+(19*320))
    .byte <($A000+(20*320)),<($A000+(21*320)),<($A000+(22*320)),<($A000+(23*320))
    .byte <($A000+(24*320))

PLOTVBASEHI:
    .byte >($A000+(0*320)),>($A000+(1*320)),>($A000+(2*320)),>($A000+(3*320))
    .byte >($A000+(4*320)),>($A000+(5*320)),>($A000+(6*320)),>($A000+(7*320))
    .byte >($A000+(8*320)),>($A000+(9*320)),>($A000+(10*320)),>($A000+(11*320))
    .byte >($A000+(12*320)),>($A000+(13*320)),>($A000+(14*320)),>($A000+(15*320))
    .byte >($A000+(16*320)),>($A000+(17*320)),>($A000+(18*320)),>($A000+(19*320))
    .byte >($A000+(20*320)),>($A000+(21*320)),>($A000+(22*320)),>($A000+(23*320))
    .byte >($A000+(24*320))

PLOT8LO:
    .byte <(0*8),<(1*8),<(2*8),<(3*8),<(4*8),<(5*8),<(6*8),<(7*8),<(8*8),<(9*8)
    .byte <(10*8),<(11*8),<(12*8),<(13*8),<(14*8),<(15*8),<(16*8),<(17*8),<(18*8),<(19*8)
    .byte <(20*8),<(21*8),<(22*8),<(23*8),<(24*8),<(25*8),<(26*8),<(27*8),<(28*8),<(29*8)
    .byte <(30*8),<(31*8),<(32*8),<(33*8),<(34*8),<(35*8),<(36*8),<(37*8),<(38*8),<(39*8)

PLOT8HI:
    .byte >(0*8),>(1*8),>(2*8),>(3*8),>(4*8),>(5*8),>(6*8),>(7*8),>(8*8),>(9*8)
    .byte >(10*8),>(11*8),>(12*8),>(13*8),>(14*8),>(15*8),>(16*8),>(17*8),>(18*8),>(19*8)
    .byte >(20*8),>(21*8),>(22*8),>(23*8),>(24*8),>(25*8),>(26*8),>(27*8),>(28*8),>(29*8)
    .byte >(30*8),>(31*8),>(32*8),>(33*8),>(34*8),>(35*8),>(36*8),>(37*8),>(38*8),>(39*8)

PLOTCVBASELO:
    .byte <($8400+(0*40)),<($8400+(1*40)),<($8400+(2*40)),<($8400+(3*40))
    .byte <($8400+(4*40)),<($8400+(5*40)),<($8400+(6*40)),<($8400+(7*40))
    .byte <($8400+(8*40)),<($8400+(9*40)),<($8400+(10*40)),<($8400+(11*40))
    .byte <($8400+(12*40)),<($8400+(13*40)),<($8400+(14*40)),<($8400+(15*40))
    .byte <($8400+(16*40)),<($8400+(17*40)),<($8400+(18*40)),<($8400+(19*40))
    .byte <($8400+(20*40)),<($8400+(21*40)),<($8400+(22*40)),<($8400+(23*40))
    .byte <($8400+(24*40))

PLOTCVBASEHI:
    .byte >($8400+(0*40)),>($8400+(1*40)),>($8400+(2*40)),>($8400+(3*40))
    .byte >($8400+(4*40)),>($8400+(5*40)),>($8400+(6*40)),>($8400+(7*40))
    .byte >($8400+(8*40)),>($8400+(9*40)),>($8400+(10*40)),>($8400+(11*40))
    .byte >($8400+(12*40)),>($8400+(13*40)),>($8400+(14*40)),>($8400+(15*40))
    .byte >($8400+(16*40)),>($8400+(17*40)),>($8400+(18*40)),>($8400+(19*40))
    .byte >($8400+(20*40)),>($8400+(21*40)),>($8400+(22*40)),>($8400+(23*40))
    .byte >($8400+(24*40))

PLOTC2VBASELO:
    .byte <($D800+(0*40)),<($D800+(1*40)),<($D800+(2*40)),<($D800+(3*40))
    .byte <($D800+(4*40)),<($D800+(5*40)),<($D800+(6*40)),<($D800+(7*40))
    .byte <($D800+(8*40)),<($D800+(9*40)),<($D800+(10*40)),<($D800+(11*40))
    .byte <($D800+(12*40)),<($D800+(13*40)),<($D800+(14*40)),<($D800+(15*40))
    .byte <($D800+(16*40)),<($D800+(17*40)),<($D800+(18*40)),<($D800+(19*40))
    .byte <($D800+(20*40)),<($D800+(21*40)),<($D800+(22*40)),<($D800+(23*40))
    .byte <($D800+(24*40))

PLOTC2VBASEHI:
    .byte >($D800+(0*40)),>($D800+(1*40)),>($D800+(2*40)),>($D800+(3*40))
    .byte >($D800+(4*40)),>($D800+(5*40)),>($D800+(6*40)),>($D800+(7*40))
    .byte >($D800+(8*40)),>($D800+(9*40)),>($D800+(10*40)),>($D800+(11*40))
    .byte >($D800+(12*40)),>($D800+(13*40)),>($D800+(14*40)),>($D800+(15*40))
    .byte >($D800+(16*40)),>($D800+(17*40)),>($D800+(18*40)),>($D800+(19*40))
    .byte >($D800+(20*40)),>($D800+(21*40)),>($D800+(22*40)),>($D800+(23*40))
    .byte >($D800+(24*40))

; ------------------------------------------------------------------------------
; MULTICOLOR MODE (MODE #3)
; ------------------------------------------------------------------------------

PLOT4LO:
    .byte <(0*4),<(1*4),<(2*4),<(3*4),<(4*4),<(5*4),<(6*4),<(7*4),<(8*4),<(9*4)
    .byte <(10*4),<(11*4),<(12*4),<(13*4),<(14*4),<(15*4),<(16*4),<(17*4),<(18*4),<(19*4)
    .byte <(20*4),<(21*4),<(22*4),<(23*4),<(24*4),<(25*4),<(26*4),<(27*4),<(28*4),<(29*4)
    .byte <(30*4),<(31*4),<(32*4),<(33*4),<(34*4),<(35*4),<(36*4),<(37*4),<(38*4),<(39*4)
    .byte <(40*4),<(41*4),<(42*4),<(43*4),<(44*4),<(45*4),<(46*4),<(47*4),<(48*4),<(49*4)
    .byte <(50*4),<(51*4),<(52*4),<(53*4),<(54*4),<(55*4),<(56*4),<(57*4),<(58*4),<(59*4)
    .byte <(60*4),<(61*4),<(62*4),<(63*4),<(64*4),<(65*4),<(66*4),<(67*4),<(68*4),<(69*4)
    .byte <(70*4),<(71*4),<(72*4),<(73*4),<(74*4),<(75*4),<(76*4),<(77*4),<(78*4),<(79*4)

PLOT4HI:
    .byte >(0*4),>(1*4),>(2*4),>(3*4),>(4*4),>(5*4),>(6*4),>(7*4),>(8*4),>(9*4)
    .byte >(10*4),>(11*4),>(12*4),>(13*4),>(14*4),>(15*4),>(16*4),>(17*4),>(18*4),>(19*4)
    .byte >(20*4),>(21*4),>(22*4),>(23*4),>(24*4),>(25*4),>(26*4),>(27*4),>(28*4),>(29*4)
    .byte >(30*4),>(31*4),>(32*4),>(33*4),>(34*4),>(35*4),>(36*4),>(37*4),>(38*4),>(39*4)
    .byte >(40*4),>(41*4),>(42*4),>(43*4),>(44*4),>(45*4),>(46*4),>(47*4),>(48*4),>(49*4)
    .byte >(50*4),>(51*4),>(52*4),>(53*4),>(54*4),>(55*4),>(56*4),>(57*4),>(58*4),>(59*4)
    .byte >(60*4),>(61*4),>(62*4),>(63*4),>(64*4),>(65*4),>(66*4),>(67*4),>(68*4),>(69*4)
    .byte >(70*4),>(71*4),>(72*4),>(73*4),>(74*4),>(75*4),>(76*4),>(77*4),>(78*4),>(79*4)


