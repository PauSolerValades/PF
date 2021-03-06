infixl 6 :+:, :-:
infixl 7 :*:, :/:

data Expr a =  N a
              | Expr a :+: Expr a  
              | Expr a :-: Expr a  
              | Expr a :*: Expr a  
              | Expr a :/: Expr a 



ejem1 = N 5.0 :+: N 3.0 :+: N 4.0
ejem2 :: Expr Integer
ejem2 = N 5 :+: N 8 :*: N 2
-- por las expresiones: N 5 :+: (N8 :*: N 2) = 21
-- NO (N 5 :+: N 8) :*: N 2 que seria 26

evaluar :: Fractional a => Expr a -> a
evaluar (N x) = x
evaluar (e1 :+: e2) = evaluar e1 + evaluar e2
evaluar (e1 :-: e2) = evaluar e1 - evaluar e2
evaluar (e1 :*: e2) = evaluar e1 * evaluar e2
evaluar (e1 :/: e2) = evaluar e1 / evaluar e2

--Ejercicios:
-- 1. Hacer (Exp a) instancia de la clase Show (mostrar como queramos) DONE
-- 2. Hacer (Exp a) instancia de la clase Eq usando evaluar (tendremos que quitar el deriving)
-- 3. Hacer (Exp a) instancia de la clase Num

instance Show a => Show (Expr a) where
    show a = case a of
        (N a)     -> show a
        (a :+: b) -> "(" ++ show a ++ "+" ++ show b ++ ")"
        (a :-: b) -> "(" ++ show a ++ "-" ++ show b ++ ")"
        (a :*: b) -> "(" ++ show a ++ "*" ++ show b ++ ")"
        (a :/: b) -> "(" ++ show a ++ "/" ++ show b ++ ")" 

instance (Eq a, Fractional a) => Eq (Expr a) where
    (N a) == (N b) = a==b
    a == b = evaluar a == evaluar b

instance (Ord a, Fractional a) => Ord (Expr a) where
    N a <= N b = a <= b
    a <= b = evaluar a <= evaluar b

{-
instance Num a => Num (Expr a) where
    N a + N b = N (a+b)
    N a - N b = N (a-b)
    N a * N b = N (a*b)
    negate (N a) = N (-a)
    abs (N a) = N a
    signum (N a) = N a
    fromInteger n = N n
-}