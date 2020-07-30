-- Definição de Monoid
class Monoid m where
	mempty  :: m
	mappend :: m -> m -> m

-- Exemplos além da multiplicação de inteiros:

-- Instância de inteiros com adição
instance Monoid Int where
	mempty  = 0
	mappend = (+)

-- Instância de listas com concatenação
instance Monoid [a] where
	mempty  = []
	mappend = (++)

-- Instância de Strings com concatenação
instance Monoid String where
	mempty  = ""
	mappend = (++)
