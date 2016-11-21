Require Import Coq.Logic.Classical_Prop.
Require Import Logic.lib.Coqlib.
Require Import Logic.MinimunLogic.LogicBase.
Require Import Logic.PropositionalLogic.Syntax.
Require Import Logic.SeparationLogic.Syntax.
Require Import Logic.PropositionalLogic.KripkeSemantics.
Require Import Logic.SeparationLogic.SeparationAlgebra.

Local Open Scope logic_base.
Local Open Scope PropositionalLogic.
Local Open Scope KripkeSemantics.
Local Open Scope SeparationLogic.

Class UpwardsSemantics (L: Language) {nL: NormalLanguage L} {pL: PropositionalLanguage L} {SL: SeparationLanguage L} (MD: Model) {kMD: KripkeModel MD} (M: Kmodel) {kiM: KripkeIntuitionisticModel MD M} {SA: SeparationAlgebra MD M} (SM: Semantics L MD) {kiSM: KripkeIntuitionisticSemantics L MD M SM}: Type := {
  sat_sepcon: forall m x y, KRIPKE: M , m |= x * y <-> exists m0 m1 m2, m <= m0 /\ join m1 m2 m0 /\ KRIPKE: M , m1 |= x /\ KRIPKE: M, m2 |= y;
  sat_wand: forall m x y, KRIPKE: M , m |= x -* y <-> forall m1 m2, join m m1 m2 -> KRIPKE: M , m1 |= x -> KRIPKE: M, m2 |= y
}.

Class UpwardsClosedUnitarySeparationAlgebra (MD: Model) {kMD: KripkeModel MD} (M: Kmodel) {kiM: KripkeIntuitionisticModel MD M} {SA: SeparationAlgebra MD M} {USA: UnitarySeparationAlgebra MD M}: Type := {
  unit_spec: forall m: Kworlds M, unit m <-> forall n n', join m n n' -> n = n';
  unit_exists: forall n: Kworlds M, exists m, join m n n /\ unit m
}.

Class UnitaryUpwardsSemantics (L: Language) {nL: NormalLanguage L} {pL: PropositionalLanguage L} {SL: SeparationLanguage L} {uSL: UnitarySeparationLanguage L} (MD: Model) {kMD: KripkeModel MD} (M: Kmodel) {kiM: KripkeIntuitionisticModel MD M} {SA: SeparationAlgebra MD M} {USA: UnitarySeparationAlgebra MD M} (SM: Semantics L MD) {kiSM: KripkeIntuitionisticSemantics L MD M SM} {usSM: UpwardsSemantics L MD M SM}: Type := {
  sat_emp: forall (m: Kworlds M), KRIPKE: M, m |= emp <-> exists n, m <= n /\ unit n
}.

