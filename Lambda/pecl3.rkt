#lang racket
(require "enteros.rkt")

;; ****************************************************
;; *************** ARTIMETICA MODULAR  ****************
;; ****************************************************

;Reducción a representante canónico: dado un entero y un módulo expesamos dicho entero en el módulo indicado.
(define representante-canonico (lambda (x)
                                 (lambda (mod)
                                   ((restoent x) mod))))

;Suma de dos números en Zp:  dados dos números entero y su módulo se devuelver el resultado de la operación.
(define suma-mod (lambda (x1)
                   (lambda (x2)
                     (lambda (mod)
                       ((representante-canonico ((sument x1) x2)) mod)))))

;Multiplicación de dos números en Zp: dados dos números entero y su múdulo se devuelver el resultado de la operación.
(define prod-mod (lambda (x1)
                   (lambda (x2)
                     (lambda (mod)
                       ((representante-canonico ((prodent x1) x2)) mod)))))

;Auxiliar par el cálculo del inverso:  dado un número y un módulo calcularemos su inverso en el caso de que lo tenga.
(define _num-inverso (lambda (recursion)
                       (lambda (n)
                         (lambda (mod)
                           (lambda (mod_original)
                             ((((esigualent (((prod-mod n) mod) mod_original)) uno)
                                  (lambda (no_use) mod)
                                  (lambda (no_use) ((((recursion recursion) n) ((restaent mod) uno)) mod_original))) zero))))))

;Cálculo del inverso:  dado un número y un módulo calcularemos su inverso en el caso de que lo tenga en caso de no tenerlo se indicará textualmente
(define num-inverso (lambda (n)
                      (lambda (mod)
                        ((((esigualent ((mcdent n) mod)) uno)
                          (lambda (no_use) ((((_num-inverso _num-inverso) n) ((restaent mod) uno)) mod))
                          (lambda (no_use) (print "** Numero sin inverso ** ")-uno)) zero))))

;; ****************************************************
;; ******************** MATRICES  *********************
;; ****************************************************

;Suma de matrices en Zp: dadas dos matrices y un módulo se proporciona el resultado.
(define suma-matrices (lambda (m1)
               (lambda (m2)
                 (lambda (mod)
                   ((((matriz (((suma-mod (primero (primero m1))) (primero (primero m2))) mod))
                      (((suma-mod (segundo (primero m1))) (segundo (primero m2))) mod))
                     (((suma-mod (primero (segundo m1))) (primero (segundo m2))) mod))
                    (((suma-mod (segundo (segundo m1))) (segundo (segundo m2))) mod))))))

;Multiplicación de matrices en Zp: dadas dos matrices y un módulo se proporciona el resultado.
(define producto-matrices (lambda (m1)
               (lambda (m2)
                 (lambda (mod)
                   ((((matriz (((suma-mod ((prodent (primero (primero m1))) (primero (primero m2)))) ((prodent (segundo (primero m1))) (primero (segundo m2)))) mod))
                      (((suma-mod ((prodent (primero (primero m1))) (segundo (primero m2)))) ((prodent (segundo (primero m1))) (segundo (segundo m2)))) mod))
                     (((suma-mod ((prodent (primero (segundo m1))) (primero (primero m2)))) ((prodent (segundo (segundo m1))) (primero (segundo m2)))) mod))
                    (((suma-mod ((prodent (primero (segundo m1))) (segundo (primero m2)))) ((prodent (segundo (segundo m1))) (segundo (segundo m2)))) mod))))))


(define determinante (lambda (m1)
                       (lambda (mod)
                         ((representante-canonico ((restaent ((prodent (primero (primero m1))) (segundo (segundo m1))))
                                                            ((prodent (segundo (primero m1))) (primero (segundo m1))))) mod))))


;Decisión sobre la inversibilidad de matrices: dada una matriz y un módulo determinamos si tendrá o no una matriz inversa.
(define inversa? (lambda (m1)
                   (lambda (mod)
                     (noesceroent ((determinante m1) mod)))))

(define adjunto (lambda (m1)
                  (lambda (mod)
                    ((((matriz ((representante-canonico (segundo (segundo m1))) mod))
                       ((representante-canonico ((restaent cero) (primero (segundo m1)))) mod))
                      ((representante-canonico ((restaent cero) (segundo (primero m1)))) mod))
                     ((representante-canonico (primero (primero m1))) mod )))))

(define transpuesta (lambda (m1)
                      ((((matriz (primero (primero m1)))
                         (primero (segundo m1)))
                        (segundo (primero m1)))
                        (segundo (segundo m1)))))

(define producto_em (lambda (m1)
                      (lambda (n)
                        (lambda (mod)
                       ((((matriz (((prod-mod (primero (primero m1))) n) mod))
                      (((prod-mod (segundo (primero m1))) n) mod))
                     (((prod-mod (primero (segundo m1))) n) mod))
                    (((prod-mod (segundo (segundo m1))) n) mod))))))

(define _inversa-matriz (lambda (m1)
                          (lambda (det)
                            (lambda (mod)
                              (((producto_em (transpuesta ((adjunto m1) mod))) ((determinante m1) mod)) mod)))))

;Calculo del inverso de una matriz: dada una matriz y un módulo calculamos su matriz inversa en el caso de que la tuviera.
(define inversa-matriz (lambda (m1)
                         (lambda (mod)
                           ((((inversa? m1) mod)
                              (lambda (no_use) (((_inversa-matriz m1) ((determinante m1) mod)) mod))
                              (lambda (no_use) (print "** Matriz sin inversa ** ")identidad)) zero))))

(define todos-cero (lambda (matriz)
                     (and (and ((esigualent (primero (primero matriz))) cero) ((esigualent (primero (segundo matriz))) cero))
                     (and ((esigualent (segundo (primero matriz))) cero) ((esigualent (segundo (segundo matriz))) cero)))))

;Rango de una matriz en Zp: dada un matriz y un módulo se raliza el cálculo.
(define rango (lambda (matriz)
                (lambda (mod)
                (((noesceroent ((determinante matriz) mod))
                                  (lambda (no_use) dos)
                                  (lambda (no_use)
                                    (((todos-cero matriz)
                                      (lambda (no_use) cero)
                                      (lambda (no_use) uno)) zero))) zero))))

(define parent? (lambda (n)
               (esceroent ((restoent n) dos))))

(define _potencia-matrices (lambda (recursion)
                             (lambda (matriz)
                               (lambda (z)
                                 (lambda (potencia)
                                   (lambda (mod)
                                     (((noesceroent potencia)
                                       (lambda (no_use)
                                         (((parent? potencia)
                                           (lambda (no_use1) (((((recursion recursion) (((producto-matrices matriz)matriz)mod)) z) ((cocienteent potencia)dos)) mod))
                                           (lambda (no_use1) (((((recursion recursion) matriz) (((producto-matrices matriz) z) mod)) ((restaent potencia)uno)) mod))) zero))
                                       (lambda (no_use) z)) zero)))))))

(define potencia-matriz (lambda (m1)
                          (lambda (potencia)
                            (lambda (mod)
                              (((((_potencia-matrices _potencia-matrices) m1) identidad) potencia) mod)))))

;; TEST 
;(testenteros (((suma-mod dos) tres) dos)) ; 1
;(testenteros (((prod-mod dos) tres) dos)) ; 0
;(testenteros ((num-inverso siete) diez))  ; 3
;(testenteros ((num-inverso tres) seis))   ; NO
;(testmatrices (((suma-matrices matriz_prueba1) matriz_prueba2) tres)) ; '((0 0) (1 2))
;(testmatrices (((producto-matrices matriz_prueba2) matriz_prueba1) tres)) ; '((0 0) (1 2))
;(testmatrices (((potencia-matriz matriz_prueba1) dos) tres)) ; '((0 1) (2 0))
;(testmatrices ((inversa-matriz matriz_prueba1) tres)) ; '((1 1) (2 1))