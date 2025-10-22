(define (domain lunar-extended)
    (:requirements :strips :typing :conditional-effects)

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
        (undeployed ?r - rover)
        (in_docking_bay ?a - astronaut ?ld - lander)
        (in_control_room ?a - astronaut ?ld - lander)
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

    (:action deploy
        :parameters (?r - rover ?a - astronaut ?ld - lander ?l - location)
        :precondition (and (lander_at ?ld ?l)
                            (undeployed ?r)
                            (in_docking_bay ?a ?ld))
        :effect (and (deployed ?r)
                    (rover_at ?r ?l)
                    (empty_memory ?r)
                    (assigned ?r ?ld)
                    (not (undeployed ?r))
        )
    )

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

    (:action take_scan
        :parameters (?r - rover ?l - location)
        :precondition (and
                        (rover_at ?r ?l)
                        (empty_memory ?r)
                        (scan_not_saved ?l)
                        (need_scan ?l))
        :effect (and (not (empty_memory ?r))
                     (carrying_scan ?r ?l)
                     (not (scan_not_saved ?l))
        )
    )

    (:action transmit_image
        :parameters (?r - rover ?a - astronaut ?ld - lander ?l - location)
        :precondition (and
                        (carrying_image ?r ?l)
                        (in_control_room ?a ?ld)
                        (assigned ?r ?ld))
        :effect (and (image_saved ?l)
                    (empty_memory ?r)
                    (not (carrying_image ?r ?l))
                    (not (image_not_saved ?l))
        )
    )

    (:action transmit_scan
        :parameters (?r - rover ?a - astronaut ?ld - lander ?l - location)
        :precondition (and
                        (carrying_scan ?r ?l)
                        (in_control_room ?a ?ld)
                        (assigned ?r ?ld))
        :effect (and (scan_saved ?l)
                    (empty_memory ?r)
                    (not (carrying_scan ?r ?l))
                    (not (scan_not_saved ?l))
        )
    )

    (:action pick_sample
        :parameters (?r - rover ?s - sample ?l - location)
        :precondition (and
                        (rover_at ?r ?l)
                        (sample_at ?s ?l)
                        (not_carrying_sample ?r ?s))
        :effect (and
                    (carrying_sample ?r ?s)
                    (not (sample_at ?s ?l))
                    (not (not_carrying_sample ?r ?s))
        )
    )

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
                    (not (lander_slot_free ?ld))
                    (not_carrying_sample ?r ?s)
        )
    )

    (:action move_to_docking_bay
        :parameters (?a - astronaut ?ld - lander)
        :precondition (and (in_control_room ?a ?ld))
        :effect (and
                    (not (in_control_room ?a ?ld))
                    (in_docking_bay ?a ?ld))
    )

    (:action move_to_control_room
        :parameters (?a - astronaut ?ld - lander)
        :precondition (and (in_docking_bay ?a ?ld))
        :effect (and
                    (not (in_docking_bay ?a ?ld))
                    (in_control_room ?a ?ld))
    )
)
