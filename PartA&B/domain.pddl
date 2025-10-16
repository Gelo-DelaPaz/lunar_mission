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
        (rover_at ?r - rover ?l - location)
        (connected ?a ?b - location)
        (lander_at ?ld - lander ?l - location)
        (deployed ?r - rover)
        (empty_mem ?r - rover)
        (carrying_image ?r - rover ?l - location)
        (carrying_scan  ?r - rover ?l - location)
        (carrying_sample ?r - rover ?s - sample)
        (sample_at ?s - sample ?l - location)
        (lander_slot_free ?ld - lander)
        (lander_has_sample ?ld - lander ?s - sample)
        (image_saved ?l - location)
        (scan_saved  ?l - location)
        (assigned ?r - rover ?ld - lander)
    )

    ; -------------------------------
    ; Actions
    ; -------------------------------
    
    ; deploy the rover at the lander’s location
    (:action deploy
        :parameters (?r - rover ?ld - lander ?x - location)
        :precondition (and
                        (lander_at ?ld ?x)
                        (not (deployed ?r)))
                        
        :effect (and
                    (deployed ?r)
                    (rover_at ?r ?x)
                    (empty_mem ?r)
                    (assigned ?r ?ld))
    )

    ; move rover along a path between two locations
    (:action move
        :parameters (?r - rover ?from ?to - location)
        :precondition (and
                        (deployed ?r) 
                        (rover_at ?r ?from) 
                        (connected ?from ?to))
        :effect (and 
                    (not (rover_at ?r ?from)) 
                    (rover_at ?r ?to))
    )

    ; take an image at a given location
    (:action take_image
        :parameters (?r - rover ?l - location)
        :precondition (and 
                        (rover_at ?r ?l) 
                        (empty_mem ?r))
        :effect (and 
                    (not (empty_mem ?r)) 
                    (carrying_image ?r ?l))
    )

    ; take a scan at a given location
    (:action take_scan
        :parameters (?r - rover ?l - location)
        :precondition (and 
                        (rover_at ?r ?l) 
                        (empty_mem ?r))
        :effect (and 
                    (not (empty_mem ?r)) 
                    (carrying_scan ?r ?l))
    )
    
    ; transmit the image to the lander
    (:action transmit_image
        :parameters (?r - rover ?ld - lander ?l - location)
        :precondition (and (carrying_image ?r ?l) (assigned ?r ?ld))
        :effect (and (image_saved ?l)
                    (empty_mem ?r)
                    (not (carrying_image ?r ?l)))
    )

    ; transmit the scan to the lander
    (:action transmit_scan
        :parameters (?r - rover ?ld - lander ?l - location)
        :precondition (and (carrying_scan ?r ?l) (assigned ?r ?ld))
        :effect (and (scan_saved ?l)
                    (empty_mem ?r)
                    (not (carrying_scan ?r ?l)))
    )
    
    ; pick up the sample from the ground
    (:action pick_sample
        :parameters (?r - rover ?l - location)
        :precondition (and (rover_at ?r ?l)
                        (empty_mem ?r)
                        (exists (?s - sample) (sample_at ?s ?l)))
        :effect (and (not (empty_mem ?r))
                    (forall (?s - sample)
                        (when (sample_at ?s ?l)
                            (and (not (sample_at ?s ?l))
                                (carrying_sample ?r ?s)))))
    )
    ; store the sample at the lander (lander capacity = 1)
    (:action store_sample
        :parameters (?r - rover ?ld - lander ?s - sample ?l - location)
        :precondition (and (rover_at ?r ?l)
                        (lander_at ?ld ?l)
                        (lander_slot_free ?ld)
                        (carrying_sample ?r ?s)
                        (assigned ?r ?ld))
                        
        :effect (and
            (empty_mem ?r)                
            (not (lander_slot_free ?ld))
            (not (carrying_sample ?r ?s))
            (lander_has_sample ?ld ?s))


    )
)