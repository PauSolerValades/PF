--- BINARY SEARCH TREES
data BST a = EmptyBST | NodeBST (BST a) a (BST a) deriving (Eq)
---------------------------------------------------
instance (Show a) => Show (BST a) where
         show EmptyBST = ""
         show t   = show' t 0 (maxLong t + 1)
                    where 
                    maxLong :: (Show a) => BST a -> Int
                    maxLong EmptyBST = 0
                    maxLong (NodeBST ai r ad) 
                         = maximum [maxLong ai,length(show r),maxLong ad]
                    show' :: (Show a) => BST a -> Int -> Int -> String
                    show' EmptyBST _ _ = " "
                    show' (NodeBST ai r ad) desde_col long_nodo
                      = dibujo_ai ++ "\n" ++ dibujo_raiz ++ dibujo_ad
                        where 
                        dibujo_raiz = [' '|i<-[1..desde_col]] ++ show r
                        dibujo_ai  = show' ai (desde_col + long_nodo) long_nodo
                        dibujo_ad = show' ad (desde_col + long_nodo) long_nodo

-----------------------------------------------------------------

createTree :: [a] -> BST a
createTree [] = EmptyBST
createTree xs = NodeBST (createTree ai) r (createTree ad)
    where 
      n = length xs
      (ai,r:ad) = splitAt (div n 2) xs

--NO HAY REPETIDOS, SI QUEREMOS LO PODEMOS IMPLEMENTAR PERO QUÉ PEREZA
bst1 = createTree [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
bst2 = createTree [1,3,5,7,9,11,13,15,17,19]
nobst = createTree [5,6,3,4,9,8,1,2,3,5,4,7,9]

-------------------------------------------------

isEmptyBST :: Eq a => BST a -> Bool
isEmptyBST t = (t == EmptyBST) --usando Eq

{-
isEmpty EmptyBST = True
isEmpty _ = False
-}

isBST :: Ord a => BST a -> Bool
isBST EmptyBST = True
isBST (NodeBST ai r ad) = isBST ai && isBST ad && (isEmptyBST ai || nodoMasDerecha ai < r) && (isEmptyBST ad || nodoMasIzquiera ad > r)
  where
    nodoMasDerecha (NodeBST bi r' bd) = if isEmptyBST bd then r' else nodoMasDerecha bd
    nodoMasIzquiera (NodeBST bi r' bd) = if isEmptyBST bi then r' else nodoMasIzquiera bi
                       
searchBST :: Ord a => a -> BST a -> Bool
searchBST _ EmptyBST = False
searchBST v (NodeBST ai r ad)
  | v == r  = True
  | v < r   = searchBST v ai
  | v > r   = searchBST v ad

--això evidentment no balanceja, s'hauria de fer una funcio balançejar
insertBST :: Ord a => a -> BST a -> BST a
insertBST v EmptyBST = NodeBST EmptyBST v EmptyBST
insertBST v (NodeBST ai r ad)
  | v == r  = NodeBST ai r ad
  | v < r   = NodeBST (insertBST v ai) r ad
  | v > r   = NodeBST ai r (insertBST v ad)

deleteBST :: Ord a => a -> BST a -> BST a
deleteBST v EmptyBST = EmptyBST
deleteBST v (NodeBST ai r ad)
  | v < r   = NodeBST (deleteBST v ai) r ad
  | v > r   = NodeBST ai r (deleteBST v ad)
  | v == r  = if isEmptyBST ai then ad else NodeBST ai' r' ad
        where 
          (r',ai') = deleteMax' ai
          deleteMax::Ord a => BST a -> (a, BST a)
          deleteMax (NodeBST l v (NodeBST a b c)) = (v, (NodeBST l b c)) -- hi ha un problema quan c i b son emptys i no l'entenc.
          --el meu delte max li fa falta ser exhausitu, si borres qualsevol cosa que nosigui una fulla peta
          deleteMax' (NodeBST bi r EmptyBST) = (r, bi)
          deleteMax' (NodeBST bi r bd) = let (r', bd') = deleteMax' bd in (r', NodeBST bd r bd')