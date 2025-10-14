(define (domain lunar)
    (:requirements :strips :typing :negative-preconditions :conditional-effects)

    ; -------------------------------
    ; Types
    ; -------------------------------
    (:types 
        rover
        lander
        location
        sample
    )

    ; -------------------------------
    ; Predicates
    ; -------------------------------
    
    (:predicates
        ; topology / placement
        (at ?r - rover ?l - location)
        (connected ?a ?b - location)
        (lander-at ?ld - lander ?l - location)
        (deployed ?r - rover)

        ; rover memory: can hold exactly one thing at a time
        (empty-mem ?r - rover)
        (carrying-image ?r - rover ?l - location)
        (carrying-scan  ?r - rover ?l - location)
        (carrying-sample ?r - rover ?s - sample)

        ; where samples exist and what lander stores
        (sample-at ?s - sample ?l - location)
        (lander-slot-free ?ld - lander)
        (lander-has-sample ?ld - lander ?s - sample)

        ; mission progress flags after transmission
        (image-saved ?l - location)
        (scan-saved  ?l - location)
    )

    ; -------------------------------
    ; Actions
    ; -------------------------------
    
    ; deploy the rover at the lander’s location (initially undeployed)
    (:action deploy
        :parameters (?r - rover ?ld - lander ?x - location)
        :precondition (and (lander-at ?ld ?x) (not (deployed ?r)))
        :effect (and (deployed ?r) (at ?r ?x) (empty-mem ?r))
    )

    ; move along a traversable edge
    (:action move
        :parameters (?r - rover ?from ?to - location)
        :precondition (and (deployed ?r) (at ?r ?from) (connected ?from ?to))
        :effect (and (not (at ?r ?from)) (at ?r ?to))
    )

    ; take an image (uses up memory)
    (:action take-image
        :parameters (?r - rover ?x - location)
        :precondition (and (at ?r ?x) (empty-mem ?r))
        :effect (and (not (empty-mem ?r)) (carrying-image ?r ?x))
    )

    ; take a subsurface scan (uses up memory)
    (:action take-scan
        :parameters (?r - rover ?x - location)
        :precondition (and (at ?r ?x) (empty-mem ?r))
        :effect (and (not (empty-mem ?r)) (carrying-scan ?r ?x))
    )

    ; transmit the image to the lander (wireless), freeing memory
    (:action transmit-image
        :parameters (?r - rover ?ld - lander ?x - location)
        :precondition (carrying-image ?r ?x)
        :effect (and (image-saved ?x)
                    (empty-mem ?r)
                    (not (carrying-image ?r ?x)))
    )

    ; transmit the scan to the lander (wireless), freeing memory
    (:action transmit-scan
        :parameters (?r - rover ?ld - lander ?x - location)
        :precondition (carrying-scan ?r ?x)
        :effect (and (scan-saved ?x)
                    (empty-mem ?r)
                    (not (carrying-scan ?r ?x)))
    )

    (:action pick-sample
        :parameters (?r - rover ?x - location)
        :precondition (and (at ?r ?x)
                        (empty-mem ?r)
                        (exists (?s - sample) (sample-at ?s ?x)))
        :effect (and (not (empty-mem ?r))
                    (forall (?s - sample)
                        (when (sample-at ?s ?x)
                            (and (not (sample-at ?s ?x))
                                (carrying-sample ?r ?s)))))
    )
    ; store the sample at the lander (lander capacity = 1)
    (:action store-sample
        :parameters (?r - rover ?ld - lander ?x - location)
        :precondition (and (at ?r ?x)
                        (lander-at ?ld ?x)
                        (lander-slot-free ?ld)
                        (exists (?s - sample) (carrying-sample ?r ?s))) ; rover has something
        :effect (and
            (empty-mem ?r)                
            (not (lander-slot-free ?ld))
            (forall (?s - sample)
                (when (carrying-sample ?r ?s)
                    (and (not (carrying-sample ?r ?s))
                        (lander-has-sample ?ld ?s)))))


    )
)