Require Import Coq.Relations.Relation_Operators.
Require Import Logic.PropositionalLogic.KripkeSemantics.
Require Import Logic.SeparationLogic.SeparationAlgebra.

Inductive MetaState (state: Type): Type :=
  | Error: MetaState state
  | NonTerminating: MetaState state
  | Terminating: state -> MetaState state.

Arguments Error {_}.
Arguments NonTerminating {_}.
Arguments Terminating {_} _.

Module Type DECREASE.

Parameter decrease: forall {state: Type} {ki_state: KripkeIntuitionisticModel state},
  MetaState state -> MetaState state -> Prop.

End DECREASE.

Module Partial <: DECREASE.

Inductive decrease'
          {state: Type}
          {ki_state: KripkeIntuitionisticModel state}:
  MetaState state -> MetaState state -> Prop :=
| decrease_Error:
    decrease' Error Error
| decrease_NonTerminating:
    decrease' NonTerminating NonTerminating
| decrease_Terminating_NonTerminating:
    forall x, decrease' (Terminating x) NonTerminating
| decrease_Terminating:
    forall x y, Korder x y -> decrease' (Terminating y) (Terminating x).

Definition decrease {state: Type} {ki_state: KripkeIntuitionisticModel state} := decrease'.

End Partial.

Module Total <: DECREASE.

Inductive decrease'
          {state: Type}
          {ki_state: KripkeIntuitionisticModel state}:
  MetaState state -> MetaState state -> Prop :=
| decrease_Error:
    decrease' Error Error
| decrease_NonTerminating:
    decrease' NonTerminating NonTerminating
| decrease_Terminating:
    forall x y, Korder x y -> decrease' (Terminating y) (Terminating x).

Definition decrease {state: Type} {ki_state: KripkeIntuitionisticModel state} := decrease'.

End Total.

Lemma Total2Partial_decrease {state: Type} {ki_state: KripkeIntuitionisticModel state}: forall ms1 ms2,
  Total.decrease ms1 ms2 -> Partial.decrease ms1 ms2.
Proof.
  intros.
  inversion H; constructor; auto.
Qed.

Inductive lift_relation {state: Type} (R: state -> MetaState state -> Prop):
  MetaState state-> MetaState state -> Prop :=
| lift_relation_Error:
    lift_relation R Error Error
| lift_relation_NonTerminating:
    lift_relation R NonTerminating NonTerminating
| lift_relation_Terminating:
    forall s ms, R s ms -> lift_relation R (Terminating s) ms.

Definition lift_Korder {state: Type} {ki_state: KripkeIntuitionisticModel state}: MetaState state -> MetaState state -> Prop := Total.decrease.

Inductive lift_join
          {state: Type}
          {J_state: Join state}:
  MetaState state -> MetaState state -> MetaState state -> Prop :=
| lift_join_Error1:
    forall mx my, lift_join Error mx my
| lift_join_Error2:
    forall mx my, lift_join mx Error my
| lift_join_NonTerminating1:
    forall x, lift_join NonTerminating (Terminating x) NonTerminating
| lift_join_NonTerminating2:
    forall x, lift_join (Terminating x) NonTerminating NonTerminating
| lift_join_NonTerminating3:
    lift_join NonTerminating NonTerminating NonTerminating
| lift_join_Terminating:
    forall x y z,
      join x y z ->
      lift_join (Terminating x) (Terminating y) (Terminating z).

Definition lift_function {A B: Type} (f: A -> B): MetaState A -> MetaState B :=
  fun ma =>
  match ma with
  | NonTerminating => NonTerminating
  | Error => Error
  | Terminating a => Terminating (f a)
  end.


(*
Instance MetaState_SA (state: Type) {SA: SeparationAlgebra state}: SeparationAlgebra (MetaState state).
*)

Lemma lift_relation_forward {state: Type} (R: state -> MetaState state -> Prop):
  forall x y, lift_relation R x y ->
  match x with
  | Error => y = Error
  | NonTerminating => y = NonTerminating
  | _ => True
  end.
Proof.
  intros.
  destruct x, y; inversion H; subst; try congruence; auto.
Qed.

Lemma clos_refl_trans_lift_relation_forward {state: Type} (R: state -> MetaState state -> 
Prop):
  forall x y, clos_refl_trans _ (lift_relation R) x y ->
  match x with
  | Error => y = Error
  | NonTerminating => y = NonTerminating
  | _ => True
  end.
Proof.
  intros.
  induction H.
  + apply lift_relation_forward in H; auto.
  + destruct x; auto.
  + destruct x; subst; simpl; subst; auto.
Qed.

Lemma lift_function_rev {A B: Type} (f: A -> B):
  forall ma mb, lift_function f ma = mb ->
  match mb with
  | NonTerminating => ma = NonTerminating
  | Error => ma = Error
  | _ => True
  end.
Proof.
  intros.
  destruct mb, ma; auto; simpl in *; congruence.
Qed.


