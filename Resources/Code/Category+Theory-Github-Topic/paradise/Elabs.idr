module Elabs
import Language.Reflection.Elab

%language ElabReflection
-- https://github.com/idris-lang/Idris-dev/blob/master/libs/prelude/Language/Reflection/Elab.idr
  
addTypeDecl : Elab ()
addTypeDecl = do 
  let tname : TTName = `{{GenData}}
  declareDatatype $ Declare tname []  RType
  defineDatatype $ DefineDatatype tname []
  
%runElab addTypeDecl

genTypeTest : GenData -> ()
genTypeTest x = ()

-- https://github.com/idris-lang/Idris-dev/blob/a02bfec13cbb6a49d553d33b61ca44ff2d83c9a7/test/meta002/DataDef.idr
addTypeDecl2 : Elab ()
addTypeDecl2 = do 
  declareDatatype $ Declare `{{N}} [MkFunArg `{{n}} `(Nat) Explicit NotErased] `(Type)
  defineDatatype $ DefineDatatype `{{N}} [
           Constructor `{{MkN}} [MkFunArg `{{x}} `(Nat) Implicit NotErased] (RApp (Var `{{N}}) (Var `{{x}})),
           Constructor `{{MkN'}} [MkFunArg `{{x}} `(Nat) Explicit NotErased] (RApp (Var `{{N}}) (RApp (Var `{S}) (Var `{{x}})))]

%runElab addTypeDecl2
--N : Nat -> Type
one : N 1
one = MkN

two : N 2
two = MkN' 1

--  generate lambdas
idNat : Nat -> Nat
idNat = %runElab (do intro `{{x}}
                     fill (Var `{{x}})
                     solve)


addFunDecls : Elab ()
addFunDecls = do 
  declareType $ Declare `{{fun1}} [] `(() -> ())
  defineFunction $ DefineFun `{{fun1}} [MkFunClause `(()) `(())]

%runElab addFunDecls

fun2 : ()->()
fun2 = fun1

addImplsShow : Elab ()
addImplsShow = do
--  let instn = NS (SN $ ImplementationN `{Show} [show `{{a}}]) !currentNamespace
  addImplementation `{Show} `{{x}} -- x is placeholder,  not working yet!

-- An Elab script to insert plus Z (S Z)
isrt : Elab ()
isrt = do 
  [x, y] <- apply `(plus) [False, False]
  solve
  focus x; fill `(Z); solve
  focus y; fill `(S Z); solve
