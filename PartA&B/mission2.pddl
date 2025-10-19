(define (problem lunar-mission-2)
    (:domain lunar)

    (:objects
        rover1 rover2 - rover
        lander1 lander2 - lander
        wp1 wp2 wp3 wp4 wp5 wp6 - location
        sample1 sample2 - sample
    )

    (:init
        ;; Lander 1 sits at WP2
        (lander_at lander1 wp2)
        (lander_slot_free lander1)

        ;; Rover 1 starts already deployed at WP2
        (deployed rover1)
        (rover_at rover1 wp2)
        (assigned rover1 lander1)

        ;; Lander 2 sits at WP1
        (lander_at lander2 wp5)
        (lander_slot_free lander2)

        ;; Rover 1 memory start empty
        (empty_memory rover1)

        ;; Physical samples location
        (sample_at sample1 wp5)
        (sample_at sample2 wp1)

        ;; Images/scans needed
        (need_image wp3)
        (need_image wp2)
        (need_scan wp4)
        (need_scan wp6)

        ;; Map for Mission 2
        (connected wp1 wp2) (connected wp2 wp1)
        (connected wp2 wp3)
        (connected wp2 wp4) (connected wp4 wp2)
        (connected wp3 wp5) (connected wp5 wp3)
        (connected wp5 wp6)
        (connected wp6 wp4)
    )

    (:goal
        (and
            (image_saved wp3)
            (scan_saved wp4)
            (image_saved wp2)
            (scan_saved wp6)
            (rover_at rover1 wp2)
            (rover_at rover2 wp5)
            (exists (?s - sample) (lander_has_sample lander1 ?s))
            (exists (?s - sample) (lander_has_sample lander2 ?s))
        )
    )
)