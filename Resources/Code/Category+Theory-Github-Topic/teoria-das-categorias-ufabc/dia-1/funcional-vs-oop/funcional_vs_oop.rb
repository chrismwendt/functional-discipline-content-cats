# 1. Implemente a estrutura Shape como um interface na sua linguagem OOP favorita! Compare a quantidade de linhas de código.

class Circle
  def initialize(r)
    @r = r
  end
  def area
    Math::PI * @r * @r
  end
end

class Rect
  def initialize(d, h)
    @d = d
    @h = h
  end
  def area
    @d * @h
  end
end

# A vantagem aqui é que não existem interfaces como em linguagens estaticamente tipadas,
# a única coisa necessária é criar um método `area` para "implementar" a interface.
#
# Haskell: 5 linhas
# Ruby: 17 linhas

# 2. Acrescente essa função na interface criada no exercício anterior. Marque as linhas de código que você teve que alterar.

# Reabrir as classes para adicionar o método circ
class Circle
  def circ
    2.0 * Math::PI * @r
  end
end

class Rect
  def circ
    2.0 * (@d + @h)
  end
end

# Aqui só foi necessário adicionar as duas funções as duas classes, 3 linhas por implementação de `circ`.
# O código `class T` repetido é desnecessário, pois poderia estar na primeira definição da classe.

# 3. Adicione a forma Square tanto no tipo Shape do Haskell como na interface implementada por você. O que teve que ser feito em Haskell e na sua linguagem favorita?

# Haskell:

# Código:
# data Shape = Circle Float
#            | Rect Float Float
#            | Square Float
#
# area :: Shape -> Float
# area (Circle r) = pi * r * r
# area (Rect d h) = d * h
# area (Square s) = s * s
#
# circ :: Shape -> Float
# circ (Circle r) = 2.0 * pi * r
# circ (Rect d h) = 2.0 * (d + h)
# circ (Square s) = 2.0 * (s + s)

# Qtd de linhas: 3
#  - 1 na definição do tipo
#  - 1 na função area
#  - 1 na função circ

# Ruby: 11 linhas (3 na definição da função area e 3 na definição da função circ)

# Código:
class Square
  def initialize(s)
    @s = s
  end
  def area
    @s * @s
  end
  def circ
    2.0 * (@s + @s)
  end
end

# Qtd de linhas: 11
#  - 2 na definição da classe
#  - 3 no construtor
#  - 3 na função area
#  - 3 na função circ

# Exemplos de uso:

puts Circle.new(3).area # 28.274333882308138
puts Circle.new(3).circ # 18.84955592153876

puts Rect.new(2, 8).area # 16
puts Rect.new(2, 8).circ # 20

puts Square.new(12).area # 144
puts Square.new(12).circ # 48.0
