(define (domain lunar-extended)
    (:requirements :strips :typing :negative-preconditions)

    (:types
        rover
        lander
        location
        sample
        astronaut
    )

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

        ; rover capacity
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

    ; pick up a physical sample (occupies the single memory/carry slot)
    (:action pick-sample
        :parameters (?r - rover ?s - sample ?x - location)
        :precondition (and (at ?r ?x) (sample-at ?s ?x) (empty-mem ?r))
        :effect (and (carrying-sample ?r ?s)
                    (not (sample-at ?s ?x))
                    (not (empty-mem ?r)))
    )

    ; store the sample at the lander (lander capacity = 1)
    (:action store-sample
        :parameters (?r - rover ?ld - lander ?s - sample ?x - location)
        :precondition (and (at ?r ?x) (lander-at ?ld ?x)
                        (carrying-sample ?r ?s)
                        (lander-slot-free ?ld))
        :effect (and (lander-has-sample ?ld ?s)
                    (empty-mem ?r)
                    (not (carrying-sample ?r ?s))
                    (not (lander-slot-free ?ld)))
    )
)