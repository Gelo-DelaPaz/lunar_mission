(define (domain lunar-extended)
    (:requirements :strips :typing :negative-preconditions :conditional-effects)

    (:types
        rover
        lander
        location
        sample
        astronaut
    )

    (:predicates
        (rover_at ?r - rover ?l - location)
        (connected ?a ?b - location)
        (lander_at ?ld - lander ?l - location)
        (deployed ?r - rover)
        (in_docking_bay ?a - astronaut ?ld - lander)
        (in_control_room ?a - astronaut ?ld - lander)
        (empty_memory ?r - rover)
        (carrying_image ?r - rover ?l - location)
        (carrying_scan  ?r - rover ?l - location)
        (assigned ?r - rover ?ld - lander)
        (carrying_sample ?r - rover ?s - sample)
        (sample_at ?s - sample ?l - location)
        (lander_slot_free ?ld - lander)
        (lander_has_sample ?ld - lander ?s - sample)
        (image_saved ?l - location)
        (scan_saved  ?l - location)
    )

     ; -------------------------------
    ; Actions
    ; -------------------------------
    
    ; deploy the rover at the lander’s location (initially undeployed)
    (:action deploy
        :parameters (?r - rover ?a - astronaut ?ld - lander ?l - location)
        :precondition (and (lander_at ?ld ?l)
                            (not (deployed ?r))
                            (in_docking_bay ?a ?ld))
        :effect (and (deployed ?r)
                    (rover_at ?r ?l)
                    (empty_memory ?r)
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

    ; take an image at a specific location
    (:action take_image
        :parameters (?r - rover ?x - location)
        :precondition (and 
                        (rover_at ?r ?x)
                        (empty_memory ?r))
        :effect (and
                    (not (empty_memory ?r))
                    (carrying_image ?r ?x))
    )

    ; take a subsurface scan
    (:action take_scan
        :parameters (?r - rover ?x - location)
        :precondition (and (rover_at ?r ?x) (empty_memory ?r))
        :effect (and (not (empty_memory ?r)) (carrying_scan ?r ?x))
    )

    ; transmit the image to the lander
    (:action transmit_image
        :parameters (?r - rover ?a - astronaut ?ld - lander ?x - location)
        :precondition (and 
                        (carrying_image ?r ?x)
                        (in_control_room ?a ?ld)
                        (assigned ?r ?ld))
        :effect (and (image_saved ?x)
                    (empty_memory ?r)
                    (not (carrying_image ?r ?x)))
    )

    ; transmit the scan to the lander (wireless), freeing memory
    (:action transmit_scan
        :parameters (?r - rover ?a - astronaut ?ld - lander ?x - location)
        :precondition (and
                        (carrying_scan ?r ?x)
                        (in_control_room ?a ?ld)
                        (assigned ?r ?ld))
        :effect (and (scan_saved ?x)
                    (empty_memory ?r)
                    (not (carrying_scan ?r ?x)))
    )

    ; pick up a sample from the ground
    (:action pick_sample
        :parameters (?r - rover ?s - sample ?x - location)
        :precondition (and 
                        (rover_at ?r ?x)
                        (sample_at ?s ?x)
                        (not (carrying_sample ?r ?s)))
        :effect (and
                    (carrying_sample ?r ?s)
                    (not (sample_at ?s ?x)))
    )

    ; store the sample at the lander
    (:action store_sample
        :parameters (?r - rover ?a - astronaut ?ld - lander ?s - sample ?l - location)
        :precondition (and
                        (rover_at ?r ?l)
                        (lander_at ?ld ?l)
                        (carrying_sample ?r ?s)
                        (lander_slot_free ?ld)
                        (in_docking_bay ?a ?ld)
                        (assigned ?r ?ld))
        :effect (and (lander_has_sample ?ld ?s)
                    (not (carrying_sample ?r ?s))
                    (not (lander_slot_free ?ld)))
    )

    (:action move_to_docking
        :parameters (?a - astronaut ?ld - lander)
        :precondition (and (in_control_room ?a ?ld))
        :effect (and
                    (not (in_control_room ?a ?ld))
                    (in_docking_bay ?a ?ld))
    )

    (:action move_to_control-room
        :parameters (?a - astronaut ?ld - lander)
        :precondition (and (in_docking_bay ?a ?ld))
        :effect (and
                    (not (in_docking_bay ?a ?ld))
                    (in_control_room ?a ?ld))
    )  
)