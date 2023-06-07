Require Import Naturelle.
Section Session1_2019_Logique_Exercice_2.

Variable A B : Prop.

Theorem Exercice_2_Naturelle : (~A) \/ B -> (~A) \/ (A /\ B).
Proof.
I_imp H.
E_ou A (~A).
TE.
I_imp H0.
I_ou_d.
I_et.
Hyp H0.
E_ou (~A) B.
Hyp H.
I_imp H1.
absurde H2.
E_non A.
Hyp H0.
Hyp H1.
I_imp H1.
Hyp H1.
I_imp H0.
I_ou_g.
Hyp H0.
Qed.

Theorem Exercice_2_Coq : (~A) \/ B -> (~A) \/ (A /\ B).
Proof.
intros.
right.
elim 0.
split.

Qed.

End Session1_2019_Logique_Exercice_2.

