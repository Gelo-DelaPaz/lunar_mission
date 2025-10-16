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
        (docking_bay_occupied ?ld - lander)
        (control_room_occupied ?ld - lander)
        (empty_mem ?r - rover)
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
        :parameters (?r - rover ?ld - lander ?x - location)
        :precondition (and (lander_at ?ld ?x)
                            (not (deployed ?r))
                            (docking_bay_occupied ?ld))
        :effect (and (deployed ?r)
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

    ; take an image
    (:action take_image
        :parameters (?r - rover ?x - location)
        :precondition (and 
                        (rover_at ?r ?x)
                        (empty_mem ?r))
        :effect (and
                    (not (empty_mem ?r))
                    (carrying_image ?r ?x))
    )

    ; take a subsurface scan
    (:action take_scan
        :parameters (?r - rover ?x - location)
        :precondition (and (rover_at ?r ?x) (empty_mem ?r))
        :effect (and (not (empty_mem ?r)) (carrying_scan ?r ?x))
    )

    ; transmit the image to the lander
    (:action transmit_image
        :parameters (?r - rover ?ld - lander ?x - location)
        :precondition (and 
                        (carrying_image ?r ?x)
                        (control_room_occupied ?ld)
                        (assigned ?r ?ld))
        :effect (and (image_saved ?x)
                    (empty_mem ?r)
                    (not (carrying_image ?r ?x)))
    )

    ; transmit the scan to the lander (wireless), freeing memory
    (:action transmit_scan
        :parameters (?r - rover ?ld - lander ?x - location)
        :precondition (and
                        (carrying_scan ?r ?x)
                        (control_room_occupied ?ld)
                        (assigned ?r ?ld))
        :effect (and (scan_saved ?x)
                    (empty_mem ?r)
                    (not (carrying_scan ?r ?x)))
    )

    ; pick up a physical sample (occupies the single memory/carry slot)
    (:action pick_sample
        :parameters (?r - rover ?s - sample ?x - location)
        :precondition (and (rover_at ?r ?x) (sample_at ?s ?x) (empty_mem ?r))
        :effect (and (carrying_sample ?r ?s)
                    (not (sample_at ?s ?x))
                    (not (empty_mem ?r)))
    )

    ; store the sample at the lander (lander capacity = 1)
    (:action store_sample
        :parameters (?r - rover ?ld - lander ?s - sample ?x - location)
        :precondition (and (rover_at ?r ?x) (lander_at ?ld ?x)
                        (carrying_sample ?r ?s)
                        (lander_slot_free ?ld)
                        (docking_bay_occupied ?ld)
                        (assigned ?r ?ld))
        :effect (and (lander_has_sample ?ld ?s)
                    (empty_mem ?r)
                    (not (carrying_sample ?r ?s))
                    (not (lander_slot_free ?ld)))
    )

    (:action move_to_docking
        :parameters (?a - astronaut ?ld - lander)
        :precondition (and (in_control_room ?a ?ld))
        :effect (and
                    (not (in_control_room ?a ?ld))
                    (in_docking_bay ?a ?ld)
                    (not (control_room_occupied ?ld))
                    (docking_bay_occupied ?ld))
    )

    (:action move_to_control-room
        :parameters (?a - astronaut ?ld - lander)
        :precondition (and (in_docking_bay ?a ?ld))
        :effect (and
                    (not (in_docking_bay ?a ?ld))
                    (in_control_room ?a ?ld)
                    (not (docking_bay_occupied ?ld))
                    (control_room_occupied ?ld))
    )  
    
)