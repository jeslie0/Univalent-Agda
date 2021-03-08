{-# OPTIONS --without-K --rewriting #-}
module UniAgda.equiv.inj-surj where
open import UniAgda.core.CORE public
open import UniAgda.HITs.proptrunc public

surjective : ∀ {i j} {A : Type i} {B : Type j}
       (f : A → B)
       → Type (i ⊔ j)
surjective {i} {j} {A} {B} f = (b : B) → ∥ fib f b ∥ 

surjective-is-prop : ∀ {i j} {A : Type i} {B : Type j}
                     (f : A → B)
                     → isProp (surjective f)
surjective-is-prop f =
  prop-fibres-Pi-is-prop
    λ b → Ptrunc-is-prop (fib f b)



embedding : ∀ {i j} {A : Type i} {B : Type j}
          (f : A → B)
          → Type (i ⊔ j)
embedding {i} {j} {A} {B} f = (x y : A) → isEquiv (ap {i} {j} {A} {B} {x} {y} f)

embedding-is-prop : ∀ {i j} {A : Type i} {B : Type j}
          (f : A → B)
          → isProp (embedding f)
embedding-is-prop f =
  prop-fibres-Pi-is-prop λ a →
    prop-fibres-Pi-is-prop λ b →
      isEquiv-is-prop (ap f)


injective : ∀ {i j} {A : Set_ i} {B : Set_ j}
            (f : pr₁ A → pr₁ B)
            → Type (i ⊔ j)
injective {i} {j} {A , p} {B , q} f = (x y : A) → (f x ≡ f y) → (x ≡ y)

thm4-6-3 : ∀ {i j} {A : Type i} {B : Type j} {f : A → B}
           → isEquiv f ↔ (surjective f × embedding f)
thm4-6-3 {i} {j} {A} {B} {f} =
         (λ x → (λ b → ∣ pr₁ (isEquiv-to-isContrmap x b) ∣) , λ a b → thm2-11-1 x) ,
         λ { (X , Y) → isContrmap-to-isEquiv λ y →
           pointed-prop-to-contr
             (pr₁ (pr₂ (lemma3-9-1  λ { (a , p) (a₁ , q) →
               path-equiv-sigma ((pr₁ (Y a a₁) (p ∘ (q ^))) ,
                 tr-Pf (λ x → x ≡ y) f (pr₁ (Y a a₁) (p ∘ q ^)) p ∘
                 lemma2-11-2ii y (ap f (pr₁ (Y a a₁) (p ∘ q ^) )) p ∘
                 p=qr-to-q^p=r p q _ (pq^=r-to-p=rq p q _
                   (pr₁ (pr₂ (pr₂ (Y a a₁))) (p ∘ q ^) ^)) )}))
             (X y) ,
             λ { (a , p) (a₁ , q) → path-equiv-sigma ((pr₁ (Y a a₁) (p ∘ (q ^))) ,
               tr-Pf (λ x → x ≡ y) f (pr₁ (Y a a₁) (p ∘ q ^)) p ∘
               lemma2-11-2ii y (ap f ( pr₁ (Y a a₁) (p ∘ q ^) )) p ∘
               p=qr-to-q^p=r p q _
                 (pq^=r-to-p=rq p q _
                   (pr₁ (pr₂ (pr₂ (Y a a₁))) (p ∘ q ^) ^)) )})}


cor4-6-4 : ∀ {i j} {A : Type i} {B : Type j}
           (f : A → B)
           → isEquiv f ≃ (surjective f × embedding f)
cor4-6-4 f =
  props-equiv
    (isEquiv-is-prop f)
    (prod-of-props-is-prop
      (surjective-is-prop f)
      (embedding-is-prop f))
    (pr₁ (thm4-6-3 {f = f}))
    (pr₂ (thm4-6-3 {f = f}))

