module Parsing 

import public Text.Lexer

%default total

public export
data Token = Ident String
           | Literal Integer
           | StrLit String
           | CharLit String
           | DoubleLit Double
           | Symbol String
           | Keyword String
           | Unrecognised String
           | Comment String
           | EndInput
           
comment : Lexer
comment = exact "--" <+> many (isNot '\n')
           
rawTokens : TokenMap Token
rawTokens = [(comment, Comment)]

doParse : String-> Either String $ List (TokenData Token)                                
doParse str =case lex rawTokens str of
  (a, (_,_,""))=> Right a
  (_,(_,_,e)) => Left $ "error!   " ++ e


main : IO ()
main = do
  pure ()

