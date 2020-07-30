------------------------------------------------------------------------------
-- Abel: A brother of Cain
--
-- Natural transformations
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K                #-}

module Abel.Category.NaturalTransformation where

open import Abel.Category.Functor

open import Function using (_∘_)

open import Relation.Binary.PropositionalEquality using (_≡_)

------------------------------------------------------------------------------
-- Definition

record NT {F G : Set → Set} (functorF : Functor F)
                            (functorG : Functor G) : Set₁ where

  constructor mkNT

  open Functor functorF renaming (fmap to fmapF)
  open Functor functorG renaming (fmap to fmapG)

  field

    τ          : {A : Set} → F A → G A

    naturality : {A B : Set} {f : A → B}
                 (fx : F A) → (τ ∘ fmapF f) fx ≡ (fmapG f ∘ τ) fx
