--fibonacci NO eficiente
fib::Integer -> Integer
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

first (a,b) = a

--fibonacci SÍ eficiente
fibE::Integer -> Integer
fibE n = fst (fibPar n)
    where
        fibPar::Integer -> (Integer, Integer)
        fibPar 0 = (0,1) -- els dos primers elemtns de cop
        fibPar n = 
              let (a,b) = fibPar (n-1)
                  -- a = fib (n-1), b = fib n => a+b = fib n+1
              in (b, a+b)
--Ejercicio A MANO: CÓMO SE EVALUA fibE 3. (ta a la llibreta diari i eso.)
--EJERCICIO de evaluación o algo

--inversa ineficiente. tiene que hacerla recursión y tiene que volver otra vez.
inversa [] = []
inversa (x:xs) = inversa xs ++ [x]

--inversa si efinente (recursiva de cola)
inversaE s = invConc [] s
    where
          invConc t [] = t
          invConc t (x:xs) = invConc (x:t) xs

-- Ejercicio con iterate
digitos = reverse . map (`mod` 10) .  takeWhile (/=0) . iterate (`div` 10) 

-- La criba de Eratostenes
primos = criba [2..]
criba (p : ns) = p : criba (filter ((/= 0).(`mod`p)) ns)

-- take 100 (filter ((==7).(`mod` 10)) primos)
-- (filter ((==7).(`mod` 10)) primos) !! 99


-- Estructura cíclicas
data Arbol a = Hoja a | Nodo (Arbol a) (Arbol a) deriving Show

ca = let x =(Nodo (Nodo ca (Hoja 5)) x) 
     in Nodo x (Hoja 6)

ca' = let x =(Nodo (Nodo ca (Hoja 5)) x) 
      in Nodo (Hoja 6) x

unfold:: (Show a1, Eq a2, Num a2) => a2 -> Arbol a1 -> Arbol String
unfold _ (Hoja r) = Hoja (show r)
unfold 0 (Nodo ai ad) = Hoja " "
unfold n (Nodo ai ad) = Nodo (unfold (n-1) ai)  (unfold (n-1) ad)

-- Números de Hamming               
hamming :: [Integer] 
-- hamming es la lista infinita creciente de los números de Hamming
hamming = 1: fundir3 (map (2*) hamming)
                     (map (3*) hamming)
                     (map (5*) hamming)
          where fundir3 :: Ord a => [a] -> [a] -> [a] -> [a] 
                -- Pre: xs ys y zs son listas ordenadas crecientemente
                -- (fundir3 xs ys zs) es la lista ordenada creciente 
                --  sin repeticiones que resulta de mezclar xs, ys y zs
                fundir3 xs ys zs = fundir2 xs (fundir2 ys zs)
                fundir2 (x:xs) (y:ys)
                    | x == y = x: fundir2 xs ys     
                    | x < y  = x: fundir2 xs (y:ys)
                    | x > y  = y: fundir2 (x:xs) ys

{-
*Main> hamming !! 10000000
16244249195502759967226308067328000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
(15.08 secs, 9,476,121,264 bytes)
-}