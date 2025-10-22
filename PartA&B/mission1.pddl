(define (problem lunar-mission-1)
    (:domain lunar)

    (:objects
      rover1 - rover
      lander1 - lander
      wp1 wp2 wp3 wp4 wp5 - location
      sample1 - sample
    )

    (:init
      ;; Lander sits at WP1 
      (lander_at lander1 wp1)
      (lander_slot_free lander1)
      (undeployed rover1)
      
      ;; Physical sample on the ground at WP1
      (sample_at sample1 wp1)

      ;; Images/scans needed
      (need_image wp5)
      (need_scan wp3)

       ;; Complement predicates required by the STRIPS-only domain
      (image_not_saved wp5)                
      (scan_not_saved wp3)                 
      (not_carrying_sample rover1 sample1) 

      ;; Mission Map
      (connected wp1 wp2)
      (connected wp2 wp3)
      (connected wp1 wp4)
      (connected wp4 wp3)
      (connected wp5 wp1)
      (connected wp3 wp5)
    )

    (:goal 
      (and
        (image_saved wp5)
        (scan_saved wp3)
        (rover_at rover1 wp1)
        (lander_has_sample lander1 sample1) 
      ) 
    )
)