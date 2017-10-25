Require Import Logic.GeneralLogic.Base.
Require Import Logic.MinimunLogic.Syntax.
Require Import Logic.PropositionalLogic.Syntax.
Require Import Logic.SeparationLogic.Syntax.
Require Import Logic.MinimunLogic.ProofTheory.Normal.
Require Import Logic.MinimunLogic.ProofTheory.Minimun.
Require Import Logic.MinimunLogic.ProofTheory.RewriteClass.
Require Import Logic.PropositionalLogic.ProofTheory.Intuitionistic.
Require Import Logic.PropositionalLogic.ProofTheory.DeMorgan.
Require Import Logic.PropositionalLogic.ProofTheory.GodelDummett.
Require Import Logic.PropositionalLogic.ProofTheory.Classical.
Require Import Logic.PropositionalLogic.ProofTheory.RewriteClass.
Require Import Logic.SeparationLogic.ProofTheory.SeparationLogic.
Require Import Logic.SeparationLogic.DeepEmbedded.Parameter.
Require Logic.SeparationLogic.DeepEmbedded.SeparationEmpLanguage.

Local Open Scope logic_base.
Local Open Scope syntax.
Import PropositionalLanguageNotation.
Import SeparationLogicNotation.

Class Parametric_SeparationLogic (PAR: SL_Parameter) (L: Language) {nL: NormalLanguage L} {pL: PropositionalLanguage L} {sL: SeparationLanguage L} {s'L: SeparationEmpLanguage L} (Gamma: ProofTheory L) {nGamma: NormalProofTheory L Gamma} {mpGamma: MinimunPropositionalLogic L Gamma} {ipGamma: IntuitionisticPropositionalLogic L Gamma} {sGamma: SeparationLogic L Gamma} {eGamma: EmpSeparationLogic L Gamma} := {
  Parametric_DM: WEM PAR = true -> DeMorganPropositionalLogic L Gamma;
  Parametric_GD: IC PAR = true -> GodelDummettPropositionalLogic L Gamma;
  Parametric_C: EM PAR = true -> ClassicalPropositionalLogic L Gamma;
  Parametric_GC: SCE PAR = true -> GarbageCollectSeparationLogic L Gamma;
  Parametric_NE: ESE PAR = true -> NonsplitEmpSeparationLogic L Gamma;
  Parametric_ED: ED PAR = true -> DupEmpSeparationLogic L Gamma
}.

Section SeparationLogic.

Context (Var: Type).

Instance L: Language := SeparationEmpLanguage.L Var.
Instance nL: NormalLanguage L := SeparationEmpLanguage.nL Var.
Instance pL: PropositionalLanguage L := SeparationEmpLanguage.pL Var.
Instance sL: SeparationLanguage L := SeparationEmpLanguage.sL Var.
Instance s'L: SeparationEmpLanguage L := SeparationEmpLanguage.s'L Var.

Context (PAR: SL_Parameter).

Inductive provable: expr -> Prop :=
| modus_ponens: forall x y, provable (x --> y) -> provable x -> provable y
| axiom1: forall x y, provable (x --> (y --> x))
| axiom2: forall x y z, provable ((x --> y --> z) --> (x --> y) --> (x --> z))
| andp_intros: forall x y, provable (x --> y --> x && y)
| andp_elim1: forall x y, provable (x && y --> x)
| andp_elim2: forall x y, provable (x && y --> y)
| orp_intros1: forall x y, provable (x --> x || y)
| orp_intros2: forall x y, provable (y --> x || y)
| orp_elim: forall x y z, provable ((x --> z) --> (y --> z) --> (x || y --> z))
| falsep_elim: forall x, provable (FF --> x)
| weak_excluded_middle: WEM PAR = true -> forall x, provable (~~ x || ~~ ~~ x)
| impp_choice: IC PAR = true -> forall x y, provable ((x --> y) || (y --> x))
| excluded_middle: EM PAR = true -> forall x, provable (x || ~~ x)
| sepcon_comm: forall x y, provable (x * y --> y * x)
| sepcon_assoc: forall x y z, provable (x * (y * z) <--> (x * y) * z)
| wand_sepcon_adjoint1: forall x y z, provable (x * y --> z) -> provable (x --> (y -* z))
| wand_sepcon_adjoint2: forall x y z, provable (x --> (y -* z)) -> provable (x * y --> z)
| sepcon_emp: forall x, provable (x * emp <--> x)
| sepcon_elim1: SCE PAR = true -> forall x y, provable (x * y --> x)
| emp_sepcon_truep_elim: ESE PAR = true -> forall x, provable (x * TT && emp --> x)
| emp_dup: ED PAR = true -> forall x, provable (x && emp --> x * x).

Instance G: ProofTheory L := Build_AxiomaticProofTheory provable.

Instance nG: NormalProofTheory L G := Build_nAxiomaticProofTheory provable.

Instance mpG: MinimunPropositionalLogic L G.
Proof.
  constructor.
  + apply modus_ponens.
  + apply axiom1.
  + apply axiom2.
Qed.

Instance ipG: IntuitionisticPropositionalLogic L G.
Proof.
  constructor.
  + apply andp_intros.
  + apply andp_elim1.
  + apply andp_elim2.
  + apply orp_intros1.
  + apply orp_intros2.
  + apply orp_elim.
  + apply falsep_elim.
Qed.

Instance sG: SeparationLogic L G.
Proof.
  constructor.
  + apply sepcon_comm.
  + apply sepcon_assoc.
  + intros; split.
    - apply wand_sepcon_adjoint1.
    - apply wand_sepcon_adjoint2.
Qed.

Instance eG: EmpSeparationLogic L G.
Proof.
  constructor.
  intros.
  apply sepcon_emp.
Qed.

Instance ParG: Parametric_SeparationLogic PAR L G.
Proof.
  constructor.
  + intros; constructor.
    apply weak_excluded_middle; auto.
  + intros; constructor.
    apply impp_choice; auto.
  + intros; constructor.
    apply excluded_middle; auto.
  + intros; constructor.
    apply sepcon_elim1; auto.
  + intros; constructor.
    apply emp_sepcon_truep_elim; auto.
  + intros; constructor.
    apply emp_dup; auto.
Qed.

End SeparationLogic.
