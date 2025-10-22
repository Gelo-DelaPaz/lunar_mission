(define (domain lunar)
    (:requirements :strips :typing :conditional-effects)

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
        (undeployed ?r - rover)                
        (empty_memory ?r - rover)
        (carrying_image ?r - rover ?l - location)
        (carrying_scan  ?r - rover ?l - location)
        (carrying_sample ?r - rover ?s - sample)
        (not_carrying_sample ?r - rover ?s - sample) 
        (sample_at ?s - sample ?l - location)
        (lander_slot_free ?ld - lander)
        (lander_has_sample ?ld - lander ?s - sample)
        (image_saved ?l - location)
        (image_not_saved ?l - location)       
        (scan_saved  ?l - location)
        (scan_not_saved ?l - location)        
        (need_image ?l - location)
        (need_scan ?l - location)
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
                        (undeployed ?r))          
        :effect (and
                    (deployed ?r)
                    (rover_at ?r ?x)
                    (empty_memory ?r)
                    (assigned ?r ?ld)
                    (not (undeployed ?r))   
        )
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
                        (empty_memory ?r)
                        (image_not_saved ?l) 
                        (need_image ?l))
        :effect (and 
                    (not (empty_memory ?r)) 
                    (carrying_image ?r ?l)
                    (not (image_not_saved ?l))
        )
    )

    ; take a scan at a given location
    (:action take_scan
        :parameters (?r - rover ?l - location)
        :precondition (and 
                        (rover_at ?r ?l) 
                        (empty_memory ?r)
                        (scan_not_saved ?l)
                        (need_scan ?l))
        :effect (and 
                    (not (empty_memory ?r)) 
                    (carrying_scan ?r ?l)
                    (not (scan_not_saved ?l))   
        )
    )
    
    ; transmit the image to the lander
    (:action transmit_image
        :parameters (?r - rover ?ld - lander ?l - location)
        :precondition (and (carrying_image ?r ?l) (assigned ?r ?ld))
        :effect (and (image_saved ?l)
                    (empty_memory ?r)
                    (not (carrying_image ?r ?l))
                    (not (image_not_saved ?l)) 
        )
    )

    ; transmit the scan to the lander
    (:action transmit_scan
        :parameters (?r - rover ?ld - lander ?l - location)
        :precondition (and (carrying_scan ?r ?l) (assigned ?r ?ld))
        :effect (and (scan_saved ?l)
                    (empty_memory ?r)
                    (not (carrying_scan ?r ?l))
                    (not (scan_not_saved ?l))
        )
    )
    
    ; pick up the sample from the ground
    (:action pick_sample
        :parameters (?r - rover ?s - sample ?l - location)
        :precondition (and  (rover_at ?r ?l)
                            (sample_at ?s ?l)
                            (not_carrying_sample ?r ?s)) 
        :effect (and (carrying_sample ?r ?s)
                    (not (sample_at ?s ?l))
                    (not (not_carrying_sample ?r ?s)) 
        )
    )
    
    ; store the sample at the lander
    (:action store_sample
        :parameters (?r - rover ?ld - lander ?s - sample ?l - location)
        :precondition (and (rover_at ?r ?l)
                        (lander_at ?ld ?l)
                        (lander_slot_free ?ld)
                        (carrying_sample ?r ?s)
                        (assigned ?r ?ld))
        :effect (and               
            (not (lander_slot_free ?ld))
            (not (carrying_sample ?r ?s))
            (lander_has_sample ?ld ?s)
            (not_carrying_sample ?r ?s)
        )
    )
)
