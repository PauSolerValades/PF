import Data.List
import Data.Function
import Data.Char

raices::(Float, Float, Float) -> (Float, Float)
raices (a,b,c)
       | a==0       = (-c/b,0.0)
       | dif < 0    = error "arrles complexes"
       | otherwise  = ((-b-s)/d, (-b+s)/d)
                    where   dif = b*b -4*a*c
                            s = sqrt dif
                            d = 2*a

positLista::[Int]->[Int]
positLista [] = []
positLista (x:s) = if x > 0 then x:(positLista s) else positLista s

--Ejercicio 1
quitaUltimo [] = []
quitaUltimo (x:s) = if s /= [] then x:(quitaUltimo s) else s 

quitaUno x (y:ys) = if x == y then ys else y : quitaUno x ys

--version no curryficada de quitaUno
quitaUno':: (Eq a) => (a, [a]) -> [a]
quitaUno' (_,[]) = []
quitaUno' (x, (y:ys)) = if x == y then ys else y : quitaUno' (x, ys)
-- amb -t (funcio) torna el tipus de la funció

--Ejercicio 2
isIn::Int->[Int]->Bool
isIn a (x:s)
        | x == a    = True
        | s == []   = False
        | otherwise = isIn a s

quitaRep [] = []
quitaRep (x:s) = if isIn x s then quitaRep s else x : quitaRep s

quitarRep' [] = []
quitarRep' (x:xs) = x : quitarRep' (quitarTodos x xs)
                  where
                  quitarTodos _ [] = []
                  quitarTodos z (y:ys) = if z == y then quitarTodos z ys else y : quitarTodos z ys

--per ajuntar una element a una llista, poses x:s, com després del else. El primer igual de quitaRep [] = [] serveix per parar la recursió, és a dir, si arriba llista buida d'argument, retona llista buida.

--Ejercicio 3
dif:: (Eq a) => [a] -> [a] -> [a]
dif xs [] = xs --és a dir, que si els arguments son una llista i llista buida, torna la llista.
dif xs (y:ys) = dif (quitaUno y xs) ys

--Ejercicio 4
perm:: (Eq a) => [a] -> [a] -> Bool
perm xs ys = (dif xs ys == []) && (dif ys xs == [])

--Ejercicio 5
--Si compares llistes necessites el Eq(a)
sonpermde1:: (Eq a) => [[a]] -> [[a]]
sonpermde1 [] = [] --això és la llista que no conté cap llista.
sonpermde1 (x:xs) = x:sonperm x xs
                    where 
                    sonperm:: (Eq a) => [a] -> [[a]] -> [[a]]
                    sonperm y [] = []
                    sonperm y (z:zs) = if perm z y then z:sonperm y zs else sonperm y zs

sonpermde2::(Eq a) => [[a]] -> [[a]]
sonpermde2 [] = []
sonpermde2 (x:xs) = x:filter (perm x) xs

--Ejercicio 6
timesTen [] = []
timesTen (x:xs)
        | xs /= []      = x*10^(length xs):timesTen xs
        | xs == []      = x:xs

aDecimal'::[Int]->Int
aDecimal' xs = foldr (+) 0 (timesTen xs)

aDecimal::[Int]->Int
aDecimal xs = foldl g 0 xs
    where 
        g x y = 10*x + y


aDigit 0 = []
aDigit x = aDigit (x `div` 10) ++ [x `mod` 10]

aDigitos::Int->[Int]
aDigitos n
        | 0 <= n && n <= 9 = [n] --caso simple
        | otherwise = aDigitos (n `div` 10) ++ [n `mod` 10]

--Ejercicio 7
--decimalAbinario::Int->Int
division::Int->[Int]
division d = if quotient >= 2 then residue:division(quotient)
    else residue:(quotient:[])
        where
            residue = d `mod` 2
            quotient = div d 2

decimalAbinario d = (foldr (\x y -> 10*y + x) (0). division) d
decimalAbinario' d = (aDecimal.(reverse.division)) d

{-
a::Int->Int
a d = if quotient >= 2 then residue:a(quotient)
    else add(residue:(quotient:[]))
        where
            residue = d `mod` 2
            quotient = div d 2
            add::[Int]->Int
            add xs = foldr (\x y -> 10*y + x) (0) xs
            
-}

binarioAdecimal b = (foldl (\x y -> 2*x+y) (0).aDigitos) b
 
 
--8.
ordenada:: (Ord a) => [a]->Bool --Ord a: per a tot a amb propietat ORDENABLE, executa la funció.
ordenada (x:xs)
    | xs == []       = True
    | (x <= head xs) = ordenada(xs)
    | otherwise      = False

 
--9.
{-en aquesta es fan dos recorreguts de la mateixa llista, un per take i un per drop-}

palabras:: String->[String]
palabras s = if s' == "" then []
             else (tomarPal1 s' : palabras (saltarPal1 s'))
             where
             s' = saltarBlancos s
             saltarBlancos = dropWhile (== ' ')
             tomarPal1 = takeWhile (/= ' ')
             saltarPal1 = dropWhile (/= ' ')

{-en aquest no passa, ja que span només fa una passada. Posem el patró de la tupla per capturar una cosa en el primer element i un altre al segon. amb w i s'' conectarem tot lo altre. Això és l'exemple de com unir les llistes amb l'string i la recursió-}        
listPal s = case dropWhile isSpace s of
    "" -> []
    s' -> w : palabras s''
        where (w,s'') = break isSpace s' --span !isSpace s' == takeWhile isSpace s', dropWhile !isSpace
        
--10.
posiciones x xs = [p | (e,p) <- zip xs [0..], e==x]

--11.

paraTodo p xs = length(filter (p) xs) == length xs
existe p xs = (filter (p) xs) == []

paraTodo'::(a->Bool)->[a]->Bool
paraTodo' p xs = and[p(k) | k <- xs]
existe' p xs = or[p(k) | k <- xs]

--12.
perms :: (Eq a) => [a] -> [[a]]
perms [] = [[]]
perms p = [x:xs | x <- p, xs <- perms (delete x p)]
          where
          delete x xs = fst (partition (/=x) xs) 
          --partition parteix la llista en dos seguint la condició p

--13.

sublista s1 s2 = and [booleano i | i <- s1]
   where
   booleano i  = if (filter (==i) s2) == [] then False else True

--15.

diag::String->String
diag s = concat (aux 0 (map(:"\n") s))
    where
    aux::Int->[String]->[[Char]]
    aux i (x:xs)
        | xs == []        = (replicate i " ")++[x]
        | otherwise       = (replicate i " ")++(x:(aux (i+1) xs))
    
--filoxenia el rapto a europa
