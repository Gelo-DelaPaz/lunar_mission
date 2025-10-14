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
    (lander-at lander1 wp2)
    (lander-slot-free lander1)

    ;; Rover 1 starts already deployed at WP2
    (deployed rover1)
    (at rover1 wp2)

    ;; Lander 2 sits at WP1
    (lander-at lander2 wp1)
    (lander-slot-free lander2)

    ;; Rover 2 starts undeployed
    (not (deployed rover2))

    ;; Map for Mission 2
    (connected wp1 wp2)
    (connected wp2 wp1)
    (connected wp2 wp3)
    (connected wp2 wp4)
    (connected wp3 wp5)
    (connected wp4 wp2)
    (connected wp5 wp3)
    (connected wp5 wp6)
    (connected wp6 wp4)
    )

    (:goal
        (and
            (image-saved wp3)
            (scan-saved wp4)
            (image-saved wp2)
            (scan-saved wp6)
            (lander-has-sample)
        )
    )
)