#lang typed/racket

(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt")
(require "../include/cs151-universe.rkt")

(require typed/test-engine/racket-tests)

(define-struct (Some T)
  ([value : T]))

(define-type (Optional T)
  (U 'None (Some T)))

(define-type TickInterval
  Positive-Exact-Rational)

(define-struct Date
  ([month : Integer]
   [day : Integer]
   [year : Integer]))

(define-type Stroke
  (U 'Freestyle 'Backstroke 'Breaststroke 'Butterfly))

(define-struct Event
  ([gender : (U 'Men 'Women)]
   [race-distance : Integer]
   [stroke : Stroke]
   [name : String]
   [date : Date]))

(define-type Country
  (U 'AFG 'ALB 'ALG 'AND 'ANG 'ANT 'ARG 'ARM 'ARU 'ASA 'AUS 'AUT 'AZE 'BAH
     'BAN 'BAR 'BDI 'BEL 'BEN 'BER 'BHU 'BIH 'BIZ 'BLR 'BOL 'BOT 'BRA 'BRN
     'BRU 'BUL 'BUR 'CAF 'CAM 'CAN 'CAY 'CGO 'CHA 'CHI 'CHN 'CIV 'CMR 'COD
     'COK 'COL 'COM 'CPV 'CRC 'CRO 'CUB 'CYP 'CZE 'DEN 'DJI 'DMA 'DOM 'ECU
     'EGY 'ERI 'ESA 'ESP 'EST 'ETH 'FIJ 'FIN 'FRA 'FSM 'GAB 'GAM 'GBR 'GBS
     'GEO 'GEQ 'GER 'GHA 'GRE 'GRN 'GUA 'GUI 'GUM 'GUY 'HAI 'HON 'HUN 'INA
     'IND 'IRI 'IRL 'IRQ 'ISL 'ISR 'ISV 'ITA 'IVB 'JAM 'JOR 'JPN 'KAZ 'KEN
     'KGZ 'KIR 'KOR 'KOS 'KSA 'KUW 'LAO 'LAT 'LBA 'LBN 'LBR 'LCA 'LES 'LIE
     'LTU 'LUX 'MAD 'MAR 'MAS 'MAW 'MDA 'MDV 'MEX 'MGL 'MHL 'MKD 'MLI 'MLT
     'MNE 'MON 'MOZ 'MRI 'MTN 'MYA 'NAM 'NCA 'NED 'NEP 'NGR 'NIG 'NOR 'NRU
     'NZL 'OMA 'PAK 'PAN 'PAR 'PER 'PHI 'PLE 'PLW 'PNG 'POL 'POR 'PRK 'QAT
     'ROU 'RSA 'ROC 'RUS 'RWA 'SAM 'SEN 'SEY 'SGP 'SKN 'SLE 'SLO 'SMR 'SOL
     'SOM 'SRB 'SRI 'SSD 'STP 'SUD 'SUI 'SUR 'SVK 'SWE 'SWZ 'SYR 'TAN 'TGA
     'THA 'TJK 'TKM 'TLS 'TOG 'TTO 'TUN 'TUR 'TUV 'UAE 'UGA 'UKR 'URU 'USA
     'UZB 'VAN 'VEN 'VIE 'VIN 'YEM 'ZAM 'ZIM))

(define-struct IOC
  ([abbrev : Country]
   [country : String]))

(define-struct Swimmer
  ([lname : String]
   [fname : String]
   [country : Country]
   [height : Real]))

(define-struct Result
  ([swimmer : Swimmer]
   [splits : (Listof Real)]))

(define-type Mode
  (U 'choose 'running 'paused 'done))

(define-struct (KeyValue K V)
  ([key : K]
   [value : V]))
         
(define-struct (Association K V)
  ([key=? : (K K -> Boolean)]
   [data : (Listof (KeyValue K V))]))

(define-struct FileChooser
  ([directory : String]
   [chooser : (Association Char String)])) ;; a map of chars #\a, #\b etc.
;; to file names

(define-struct Sim
  ([mode : Mode]
   [event : Event]
   [tick-rate : TickInterval]
   [sim-speed : (U '1x '2x '4x '8x)]
   [sim-clock : Real]
   [pixels-per-meter : Integer]
   [pool : (Listof Result)] ;; in lane order
   [labels : Image] ;; corresponding to lane order
   [ranks : (Listof Integer)] ;; in lane order
   [end-time : Real]
   [file-chooser : (Optional FileChooser)]))

(define-struct Position
  ([x-position : Real]
   [direction : (U 'east 'west 'finished)]))

(: ioc-abbrevs (Listof IOC))
(define ioc-abbrevs
  (list (IOC 'AFG "Afghanistan")
        (IOC 'ALB "Albania")
        (IOC 'ALG "Algeria")
        (IOC 'AND "Andorra")
        (IOC 'ANG "Angola")
        (IOC 'ANT "Antigua Barbuda")
        (IOC 'ARG "Argentina")
        (IOC 'ARM "Armenia")
        (IOC 'ARU "Aruba")
        (IOC 'ASA "American Samoa")
        (IOC 'AUS "Australia")
        (IOC 'AUT "Austria")
        (IOC 'AZE "Azerbaijan")
        (IOC 'BAH "Bahamas")
        (IOC 'BAN "Bangladesh")
        (IOC 'BAR "Barbados")
        (IOC 'BDI "Burundi")
        (IOC 'BEL "Belgium")
        (IOC 'BEN "Benin")
        (IOC 'BER "Bermuda")
        (IOC 'BHU "Bhutan")
        (IOC 'BIH "Bosnia Herzegovina")
        (IOC 'BIZ "Belize")
        (IOC 'BLR "Belarus")
        (IOC 'BOL "Bolivia")
        (IOC 'BOT "Botswana")
        (IOC 'BRA "Brazil")
        (IOC 'BRN "Bahrain")
        (IOC 'BRU "Brunei")
        (IOC 'BUL "Bulgaria")
        (IOC 'BUR "Burkina Faso")
        (IOC 'CAF "Central African Republic")
        (IOC 'CAM "Cambodia")
        (IOC 'CAN "Canada")
        (IOC 'CAY "Cayman Islands")
        (IOC 'CGO "Congo Brazzaville")
        (IOC 'CHA "Chad")
        (IOC 'CHI "Chile")
        (IOC 'CHN "China")
        (IOC 'CIV "Cote dIvoire")
        (IOC 'CMR "Cameroon")
        (IOC 'COD "Congo Kinshasa")
        (IOC 'COK "Cook Islands")
        (IOC 'COL "Colombia")
        (IOC 'COM "Comoros")
        (IOC 'CPV "Cape Verde")
        (IOC 'CRC "Costa Rica")
        (IOC 'CRO "Croatia")
        (IOC 'CUB "Cuba")
        (IOC 'CYP "Cyprus")
        (IOC 'CZE "Czechia")
        (IOC 'DEN "Denmark")
        (IOC 'DJI "Djibouti")
        (IOC 'DMA "Dominica")
        (IOC 'DOM "Dominican Republic")
        (IOC 'ECU "Ecuador")
        (IOC 'EGY "Egypt")
        (IOC 'ERI "Eritrea")
        (IOC 'ESA "El Salvador")
        (IOC 'ESP "Spain")
        (IOC 'EST "Estonia")
        (IOC 'ETH "Ethiopia")
        (IOC 'FIJ "Fiji")
        (IOC 'FIN "Finland")
        (IOC 'FRA "France")
        (IOC 'FSM "Micronesia")
        (IOC 'GAB "Gabon")
        (IOC 'GAM "Gambia")
        (IOC 'GBR "United Kingdom")
        (IOC 'GBS "Guinea-Bissau")
        (IOC 'GEO "Georgia")
        (IOC 'GEQ "Equatorial Guinea")
        (IOC 'GER "Germany")
        (IOC 'GHA "Ghana")
        (IOC 'GRE "Greece")
        (IOC 'GRN "Grenada")
        (IOC 'GUA "Guatemala")
        (IOC 'GUI "Guinea")
        (IOC 'GUM "Guam")
        (IOC 'GUY "Guyana")
        (IOC 'HAI "Haiti")
        (IOC 'HON "Honduras")
        (IOC 'HUN "Hungary")
        (IOC 'INA "Indonesia")
        (IOC 'IND "India")
        (IOC 'IRI "Iran")
        (IOC 'IRL "Ireland")
        (IOC 'IRQ "Iraq")
        (IOC 'ISL "Iceland")
        (IOC 'ISR "Israel")
        (IOC 'ISV "US Virgin Islands")
        (IOC 'ITA "Italy")
        (IOC 'IVB "British Virgin Islands")
        (IOC 'JAM "Jamaica")
        (IOC 'JOR "Jordan")
        (IOC 'JPN "Japan")
        (IOC 'KAZ "Kazakhstan")
        (IOC 'KEN "Kenya")
        (IOC 'KGZ "Kyrgyzstan")
        (IOC 'KIR "Kiribati")
        (IOC 'KOR "South Korea")
        (IOC 'KOS "Kosovo")
        (IOC 'KSA "Saudi Arabia")
        (IOC 'KUW "Kuwait")
        (IOC 'LAO "Laos")
        (IOC 'LAT "Latvia")
        (IOC 'LBA "Libya")
        (IOC 'LBN "Lebanon")
        (IOC 'LBR "Liberia")
        (IOC 'LCA "St Lucia")
        (IOC 'LES "Lesotho")
        (IOC 'LIE "Liechtenstein")
        (IOC 'LTU "Lithuania")
        (IOC 'LUX "Luxembourg")
        (IOC 'MAD "Madagascar")
        (IOC 'MAR "Morocco")
        (IOC 'MAS "Malaysia")
        (IOC 'MAW "Malawi")
        (IOC 'MDA "Moldova")
        (IOC 'MDV "Maldives")
        (IOC 'MEX "Mexico")
        (IOC 'MGL "Mongolia")
        (IOC 'MHL "Marshall Islands")
        (IOC 'MKD "North Macedonia")
        (IOC 'MLI "Mali")
        (IOC 'MLT "Malta")
        (IOC 'MNE "Montenegro")
        (IOC 'MON "Monaco")
        (IOC 'MOZ "Mozambique")
        (IOC 'MRI "Mauritius")
        (IOC 'MTN "Mauritania")
        (IOC 'MYA "Myanmar Burma")
        (IOC 'NAM "Namibia")
        (IOC 'NCA "Nicaragua")
        (IOC 'NED "Netherlands")
        (IOC 'NEP "Nepal")
        (IOC 'NGR "Nigeria")
        (IOC 'NIG "Niger")
        (IOC 'NOR "Norway")
        (IOC 'NRU "Nauru")
        (IOC 'NZL "New Zealand")
        (IOC 'OMA "Oman")
        (IOC 'PAK "Pakistan")
        (IOC 'PAN "Panama")
        (IOC 'PAR "Paraguay")
        (IOC 'PER "Peru")
        (IOC 'PHI "Philippines")
        (IOC 'PLE "Palestinian Territories")
        (IOC 'PLW "Palau")
        (IOC 'PNG "Papua New Guinea")
        (IOC 'POL "Poland")
        (IOC 'POR "Portugal")
        (IOC 'PRK "North Korea")
        (IOC 'QAT "Qatar")
        (IOC 'ROU "Romania")
        (IOC 'RSA "South Africa")
        (IOC 'ROC "Russia")
        (IOC 'RUS "Russia")
        (IOC 'RWA "Rwanda")
        (IOC 'SAM "Samoa")
        (IOC 'SEN "Senegal")
        (IOC 'SEY "Seychelles")
        (IOC 'SGP "Singapore")
        (IOC 'SKN "St Kitts Nevis")
        (IOC 'SLE "Sierra Leone")
        (IOC 'SLO "Slovenia")
        (IOC 'SMR "San Marino")
        (IOC 'SOL "Solomon Islands")
        (IOC 'SOM "Somalia")
        (IOC 'SRB "Serbia")
        (IOC 'SRI "Sri Lanka")
        (IOC 'SSD "South Sudan")
        (IOC 'STP "Sao Tome Principe")
        (IOC 'SUD "Sudan")
        (IOC 'SUI "Switzerland")
        (IOC 'SUR "Suriname")
        (IOC 'SVK "Slovakia")
        (IOC 'SWE "Sweden")
        (IOC 'SWZ "Eswatini")
        (IOC 'SYR "Syria")
        (IOC 'TAN "Tanzania")
        (IOC 'TGA "Tonga")
        (IOC 'THA "Thailand")
        (IOC 'TJK "Tajikistan")
        (IOC 'TKM "Turkmenistan")
        (IOC 'TLS "Timor Leste")
        (IOC 'TOG "Togo")
        (IOC 'TTO "Trinidad Tobago")
        (IOC 'TUN "Tunisia")
        (IOC 'TUR "Turkey")
        (IOC 'TUV "Tuvalu")
        (IOC 'UAE "United Arab Emirates")
        (IOC 'UGA "Uganda")
        (IOC 'UKR "Ukraine")
        (IOC 'URU "Uruguay")
        (IOC 'USA "United States")
        (IOC 'UZB "Uzbekistan")
        (IOC 'VAN "Vanuatu")
        (IOC 'VEN "Venezuela")
        (IOC 'VIE "Vietnam")
        (IOC 'VIN "St Vincent Grenadines")
        (IOC 'YEM "Yemen")
        (IOC 'ZAM "Zambia")
        (IOC 'ZIM "Zimbabwe")))

(: isolate-seconds : Real -> String)
;; returns the seconds and milliseconds of a given time as a string
;; ie 62.23 -> "02.23"
(define (isolate-seconds t)
  (if (< t 60)
      (if (< t 10) (string-append "0" (real->decimal-string t 2))
          (real->decimal-string t 2))
      (isolate-seconds (- t 60))))

(: mmsshh : Real -> String)
;; display an amount of time in MM:SS.HH format
;; where HH are hundredths of seconds
;; - don't worry about hours, since races are at most
;;   a few minutes long
;; - *do* append a trailing zero as needed
;; ex: (mmsshh 62.23) -> "1:02.23"
;; ex: (mmsshh 62.2)  -> "1:02.20"
(define (mmsshh t)
  (cond
    [(< t 60) (number->string t)]
    [else (string-append (number->string (exact-floor (/ t 60))) ":"
                         (isolate-seconds t))]))

(: is-country? : Country IOC -> Bool)
;; checks if the given country is the same as the given
;; IOC value from ioc-abbrevs
(define (is-country? c ioc)
  (match ioc
    [(IOC abbrev country)
     (symbol=? abbrev c)]))

(: get-ioc : Country -> IOC)
;; takes a country and returns the corresponding
;; IOC value from ioc-abbrevs
(define (get-ioc c)
  (list-ref (filter (λ ([ioc : IOC]) (is-country? c ioc)) ioc-abbrevs) 0))

(: flag-of : Country -> Image)
;; produce an image of a country's flag
;; - use bitmap/file and find the file include/flags
;; - it is OK to raise an error for a not-found file
(define (flag-of c)
  (bitmap/file
   (string-append "../include/flags/"
                  (string-replace
                   (string-downcase
                    (local
                      {(: ioc-string : IOC -> String)
                       ;; extracts country string from IOC
                       (define (ioc-string ioc)
                         (match ioc
                           [(IOC abbrev c) c]))}
                       (ioc-string
                        (get-ioc c)))) " " "-")
                  ".png")))

;; ---------------HELPER FUNCTIONS FOR CREATING THE LABEL----------------------

(: get-lnames : (Listof Result) -> (Listof String))
;; Takes a list of results and produces a list
;; with the corresponding last names of all participants
(define (get-lnames results)
  (map (λ ([r : Result])
         (match r
           [(Result swimmer _)
            (match swimmer
              [(Swimmer lname _ _ _) lname])])) results))

(: get-fnames : (Listof Result) -> (Listof String))
;; Same as get-lnames, but for first names
(define (get-fnames results)
  (map (λ ([r : Result])
         (match r
           [(Result swimmer _)
            (match swimmer
              [(Swimmer _ fname _ _) fname])])) results))

(: max-str-length : (Listof String) -> Int)
;; returns the longest string in a list
(define (max-str-length list1)
  (match list1
    [(cons first '()) (string-length first)]
    [(cons first rest)
     (if
      (andmap (λ ([s : String])
                (> (string-length first) (string-length s))) rest)
      (string-length first)
      (max-str-length rest))]))

(: get-swimmer-list : (Listof Result) -> (Listof Swimmer))
;; Returns a list of the corresponding Swimmer to each result in a pool
(define (get-swimmer-list results)
  (map (λ ([r : Result])
         (match r
           [(Result swimmer _) swimmer])) results))
                           

(: create-label : (Listof Result) Int -> Image)
;; Creates the label for the right side of the pool
(define (create-label pool ppm)
  (local
    {(define lablength (* ppm (max-str-length (get-lnames pool))))
     (: indiv-label : Swimmer -> Image)
     ;; takes a swimmer and produces an image with the flag and name
     ;; of that swimmer in the pool
     (define (indiv-label swimmer)
       (match swimmer
         [(Swimmer lname fname c h)
          (above
           (overlay/align
            'left 'middle
            (beside
             (scale (* 0.015 ppm) (flag-of c))
             (text (string-append
                    " " (substring fname 0 1) ". " lname) 12 'black))
                          (rectangle lablength (* 2.5 ppm) 'solid 'white))
           (rectangle lablength (* .25 ppm) 'solid 'white))]))}
   (above/align
    'left
    (rectangle lablength (+ (* 2.5 ppm) (* 0.25 ppm)) 'solid 'white)
    (foldl (λ ([i1 : Image] [i2 : Image]) (above/align 'left i1 i2)) empty-image
            (map (λ ([s : Swimmer]) (indiv-label s)) (get-swimmer-list
                                                      (reverse pool))))
     (rectangle lablength (+ (* 2.5 ppm) (* 0.25 ppm)) 'solid 'white))))

;;---------------HELPER FUNCTIONS FOR CREATING THE RANKS-----------------------

(: get-ftimes : (Listof Result) -> (Listof Real))
;; Returns the total time each swimmer swam, sorted by lane
(define (get-ftimes results)
  (map (λ ([r : Result])
         (match r
           [(Result _ splits)
            (foldl + 0 splits)])) results))

(: quick-sort (All (A) (-> (Listof A) (-> A A Boolean) (Listof A))))
;; Polymorphic Quicksort
(define (quick-sort list1 comp)
  (match list1
    ['() '()]
    [(cons pivot rest)
     (append (quick-sort (filter (λ ([u : A]) (comp u pivot)) rest) comp)
             (list pivot)
             (quick-sort
              (filter (λ ([u : A]) (not (comp u pivot))) rest) comp))]))

(define-struct RankPair
  ([ftime : Real]
   [rank : Int]))

(: find-index : (Listof Real) Real -> Int)
;; Finds location of given real in list of reals
(define (find-index times ftime)
  (match times
    [(cons first rest)
     (if (= first ftime) 1
         (+ 1 (find-index rest ftime)))]))

(: build-rankpairs : (Listof Real) -> (Listof RankPair))
;; takes a sorted list of final times (fastest to slowest)
;; and pairs them with their rank
(define (build-rankpairs sftimes)
     (map (λ ([r : Real]) (RankPair r (find-index sftimes r))) sftimes))

(: get-rank : (Listof RankPair) Real -> Int)
;; Returns the rank of the given time
(define (get-rank rankpairs time)
  (match (list-ref (filter (λ ([rp : RankPair])
         (match rp
           [(RankPair ftime rank)
            (= time ftime)])) rankpairs) 0)
    [(RankPair time rank) rank]))

(: make-ranks : (Listof RankPair) (Listof Real) -> (Listof Int))
;; Takes a sorted list of rank pairs and the unsorted ftimes list,
;; checks them against each other and produces the ordered rank list
(define (make-ranks rankpairs uftimes)
  (map (λ ([r : Real]) (get-rank rankpairs r)) uftimes))

(: create-rank-list : (Listof Result) -> (Listof Int))
;; notational condensation of make-ranks for the purposes of this project
(define (create-rank-list results)
  (make-ranks (build-rankpairs (quick-sort (get-ftimes results) <))
              (get-ftimes results)))

;; ---------------------------END TIME-----------------------------------------

(: get-etime : (Listof Result) -> Real)
;; Takes a list of results and finds the largest total time among them
(define (get-etime results)
  (list-ref (quick-sort (get-ftimes results) >) 0))

(: make-sub-list : Real Result -> (Listof Real))
;; Recursively subtracts the current time over the split list, taking into
;; account the bounce point of h/2
(define (make-sub-list ctime result)
  (match result
    [(Result (Swimmer lname fname c h) splits)
     (match splits
       ['() '()]
       [(cons first rest)
        (cons (- ctime first)
              (make-sub-list (- ctime first)
                             (Result (Swimmer lname fname c h) rest)))])]))

(: find-first-neg : (Listof Real) -> Int)
;; Find index of first negative value in a list of reals (kinda, exception
;; for if there is no negative is specific to the purposes of this project)
(define (find-first-neg list1)
  (local
    {(define neglist (filter (λ ([r : Real]) (negative? r)) list1))}
  (if (= 0 (length neglist)) (length list1)
  (find-index list1
              (list-ref neglist 0)))))
        

(: current-position : Real Result -> Position)
;; the arguments to current-position are the current time and a result
;; - compute the given swimmer's current position, which
;;   includes a heading 'east or 'west, or 'finished
(define (current-position ctime result)
  (match result
    [(Result (Swimmer _ _ _ h) splits)
        (if
         (>= ctime (foldl + 0 splits)) (Position (- 50 (/ h 2)) 'finished)
            (local
              {(define clap (find-first-neg (make-sub-list ctime result)))
               (define lapsplit (list-ref splits (- clap 1)))}
              (cond
                [(= (length splits) 1)
                 (if (>= (+ h (* 50 (/ ctime (list-ref splits 0)))) 50)
                     (Position (- 50 (/ h 2)) 'finished)
                     (Position (+ (/ h 2)
                                  (* 50 (/ ctime (list-ref splits 0)))) 'east))]
                [(even? clap)
                 (if
                  (and
                   (= clap (length splits))
                   (>= (+ h (* (- 50 h)
                               (/
                                (list-ref (make-sub-list ctime result)
                                          (- clap 2)) lapsplit))) 50))
                   (Position (- 50 (/ h 2)) 'finished)
                 (Position
                  (+ (/ h 2) (* (- 50 h)
                                (/ (list-ref (make-sub-list ctime result)
                                             (- clap 2)) lapsplit))) 'east))]
                [else
                 (if (= clap 1)
                     (Position (- 50 (/ h 2) (* (- 50 h)
                                                (/ ctime lapsplit))) 'west)
                     (Position (- 50 (/ h 2)
                                  (* (- 50 h)
                                     (/ (list-ref (make-sub-list ctime result)
                                                  (- clap 2))
                                        lapsplit))) 'west))])))]))

(: get-clock : Sim -> Real)
;; gets the current swim clock time in seconds and milliseconds
(define (get-clock sim)
  (match sim
    [(Sim _ _ _ _ clock _ _ _ _ _ _)
     (exact->inexact (/ (exact-round (* 100 clock)) 100))]))

(: get-speed : Sim -> Symbol)
;; gets current speed multiplier
(define (get-speed sim)
  (match sim
    [(Sim _ _ _ speed _ _ _ _ _ _ _) speed]))

(: get-x : Position -> Real)
;; Returns only x value of position
(define (get-x position)
  (match position
    [(Position x dir) x]))

(: get-dir : Position -> (U 'east 'west 'finished))
(define (get-dir position)
  (match position
    [(Position x dir) dir]))

(: done? : Real Result -> Bool)
;; checks if a swimmer has reached the finish line of a race
(define (done? ctime result)
  (local
    {(define clap (find-first-neg (make-sub-list ctime result)))}
    (match result
      [(Result (Swimmer _ _ _ h) splits)
       (and
        (= clap (length splits))
        (>= (get-x (current-position ctime result)) (- 50 (/ h 2))))])))

(: draw-lane : Int Result Real -> Image)
;; draws a lane with a swimmer in it at their current position
(define (draw-lane ppm result clock)
  (match result
    [(Result (Swimmer _ _ _ h) splits)
       (if (done? clock result)
               (above
                (place-image
                 (overlay/align "middle" "middle"
                                (text (mmsshh
                                       (exact->inexact
                                        (/ (exact-round
                                            (* 100 (foldl + 0 splits))) 100)))
                                      11 'black)
                                (rectangle
                                 (* 1.5 ppm) (* 0.6 ppm) 'solid 'white))
                 (- (* 50 ppm) (* 1.6 ppm)) (* 1.25 ppm)
                 (rectangle (* 50 ppm) (* 2.5 ppm) 'solid 'lightblue))
                (rectangle (* 50 ppm) (* 0.25 ppm) 'solid 'black))
               (above
                (place-image
                 (overlay/align "middle" "middle"
                                (if (symbol=?
                                     (get-dir
                                      (current-position clock result)) 'west)
                                    (rotate
                                     90 (triangle (* .35 ppm) 'solid 'black))
                                    (rotate
                                     270 (triangle (* .35 ppm) 'solid 'black)))
                                (rectangle (* h ppm)
                                           (* 0.5 ppm) 'solid 'lightgreen))
                 (* (get-x (current-position clock result)) ppm)
                 (* 1.25 ppm)
                 (rectangle (* 50 ppm) (* 2.5 ppm) 'solid 'lightblue))
                (rectangle (* 50 ppm) (* 0.25 ppm) 'solid 'black)))]))

(: get-splits : (Listof Result) -> (Listof (Listof Real)))
;; gets the splits list from a list of results
(define (get-splits results)
  (map (λ ([r : Result])
         (match r
           [(Result swimmer splits) splits])) results))

(: draw-lanes-result : Int Int Int (Listof Result) (Listof Int) -> Image)
;; draws n lanes with ranks in them
(define (draw-lanes-result n acc ppm pool ranks)
  (if (= n acc) empty-image
      (above
       (place-image
        (overlay/align "middle" "middle"
                       (text (number->string (list-ref ranks acc)) 15 'black)
                       (circle (* .75 ppm) 'solid
                (cond
                  [(= (list-ref ranks acc) 1) 'gold]
                  [(= (list-ref ranks acc) 2) 'silver]
                  [(= (list-ref ranks acc) 3) 'chocolate]
                  [else "light steel blue"])))
                (* 25 ppm)
                (* 1.25 ppm)
                (place-image
                  (overlay/align "middle" "middle"
                       (text
                        (mmsshh
                         (exact->inexact
                          (/ (exact-round
                              (* 100
                                 (foldl + 0
                                        (list-ref (get-splits pool) acc))))
                             100))) 11 'black)
                       (rectangle (* 1.5 ppm) (* 0.6 ppm) 'solid 'white))
        (- (* 50 ppm) (* 1.6 ppm)) (* 1.25 ppm)
                (rectangle (* 50 ppm) (* 2.5 ppm) 'solid 'lightblue)))
        (rectangle (* 50 ppm) (* 0.25 ppm) 'solid 'black)
        (draw-lanes-result n (+ 1 acc) ppm pool ranks))))

;-----------------------END OF PROJECT 2 IMPORTS-------------------------------

(: find-assoc : All (K V) K (Association K V) -> (Optional V))
;; given a key and an association, return the corresponding value,
;; if there is one
(define (find-assoc key assoc)
  (match assoc
    [(Association key=? data)
     (match data
       ['() 'None]
       [(cons first rest)
        (match first
          [(KeyValue k v)
           (if (key=? key k) (Some v)
               (find-assoc key (Association key=? rest)))])])]))

;-----------------------------HELPERS FOR SPLIT--------------------------------

(: find-list-loc : Char (Listof Char) Int -> (Listof Int))
;; returns locations in list where target character appears
(define (find-list-loc tc list1 acc)
  (match list1
    ['() '()]
    [(cons first rest)
     (if (char=? tc first)
         (append (list acc) (find-list-loc tc rest (add1 acc)))
         (find-list-loc tc rest (add1 acc)))]))

(: take : All (α) Int (Listof α) -> (Listof α))
;; take items from list
(define (take n xs)
  (cond
    [(= n 0) '()]
    [(> n 0)
     (match xs
       [(cons first rest)
        (cons first (take (sub1 n) rest))]
       ['() (error "empty list")])]
       [else (error "negative")]))

(: drop : All (α) Int (Listof α) -> (Listof α))
;; drop n items from list
(define (drop n xs)
  (cond
    [(= n 0) xs]
    [(> n 0)
     (match xs
       [(cons first rest)
        (drop (sub1 n) rest)]
       ['() (error "empty list")])]
    [else (error "negative")]))

(: slice : All (α) Int Int (Listof α) -> (Listof α))
;; slices a list between the indices of the two given values
(define (slice sn en xs)
  (take (- en sn) (drop sn xs)))

(: slice-recur : (Listof Char) (Listof Int) Int -> (Listof String))
;; recursion for the slice portion of split-lists
(define (slice-recur clist ilist acc)
  (cons
    (substring
     (list->string
      (slice (list-ref ilist acc) (list-ref ilist (add1 acc)) clist)) 1)
   (if (= (length ilist) (+ 2 acc)) '()
       (slice-recur clist ilist (add1 acc)))))

(: split-lists : (Listof Char) (Listof Int) -> (Listof String))
;; given a list of char and a find-list-loc list, divides the list at the
;; target character points and compiles the characters into strings
(define (split-lists clist ilist)
  (cond
    [(= 0 (length ilist)) (list (list->string clist))]
    [(= 1 (length ilist))
     (list (list->string (take (list-ref ilist 0) clist))
           (list->string (drop (add1 (list-ref ilist 0)) clist)))]
      [else
       (append
        (list (list->string (take (list-ref ilist 0) clist)))
        (slice-recur clist ilist 0)
        (list (list->string (drop (add1 (last ilist)) clist))))]))

(: split : Char String -> (Listof String))
;; split a string around the given character
;; ex: (split #\x "abxcdxyyz") -> (list "ab" "cd" "yyz")
;; ex: (split #\, "Chicago,IL,60637") -> (list "Chicago" "IL" "60637")
;; ex: (split #\: "abcd") -> (list "abcd")
(define (split c str)
  (local
    {(define clist (string->list str))}
  (split-lists clist (find-list-loc c clist 0))))

;------------HELPER FUNCTIONS FOR EXTRACTING EVENT STRUCTURE-------------------

(: get-gender : String -> (U 'Men 'Women))
;; extracts gender from file
(define (get-gender file)
  (if
   (string=? "m"
             (list-ref
              (list-ref (filter
                         (λ ([l : (Listof String)])
                           (string=? "gender" (list-ref l 0)))
                         (map (λ ([s : String])
                                (split #\: s)) (file->lines file))) 0) 1))
   'Men 'Women))

(: get-distance : String -> Integer)
;; extracts distance from file
(define (get-distance file)
  (cast
   (string->number
    (list-ref
     (list-ref (filter
                (λ ([li : (Listof String)])
                  (string=? "distance" (list-ref li 0)))
                (map (λ ([s : String])
                       (split #\: s)) (file->lines file))) 0) 1)) Int))

(: get-stroke : String -> (U 'Freestyle 'Backstroke 'Breaststroke 'Butterfly))
;; extracts stroke from file
(define (get-stroke file)
  (local
    {(define stroke-string
       (list-ref
              (list-ref (filter
                         (λ ([l : (Listof String)])
                           (string=? "gender" (list-ref l 0)))
                         (map (λ ([s : String])
                                (split #\: s)) (file->lines file))) 0) 1))}
    (cond
      [(string=? "Freestyle" stroke-string) 'Freestyle]
      [(string=? "Backstroke" stroke-string) 'Backstroke]
      [(string=? "Breaststroke" stroke-string) 'Breaststroke]
      [else 'Butterfly])))

(: get-event-name : String -> String)
;; extracts event name from file
(define (get-event-name file)
  (list-ref
   (list-ref (filter
              (λ ([l : (Listof String)])
                (string=? "event" (list-ref l 0)))
              (map (λ ([s : String])
                     (split #\: s)) (file->lines file))) 0) 1))

(: get-date : String -> Date)
;; extracts date from file
(define (get-date file)
  (local
    {(define date-as-list
       (split #\| (list-ref
        (list-ref (filter
                   (λ ([l : (Listof String)])
                     (string=? "date" (list-ref l 0)))
                   (map (λ ([s : String])
                          (split #\: s)) (file->lines file))) 0) 1)))}
    (Date
     (cast (string->number (list-ref date-as-list 1)) Int)
     (cast (string->number (list-ref date-as-list 0)) Int)
     (cast (string->number (list-ref date-as-list 2)) Int))))
  


(: get-event : String -> Event)
;; given a file name, extracts the event from it
(define (get-event file)
  (Event
   (get-gender file)
   (get-distance file)
   (get-stroke file)
   (get-event-name file)
   (get-date file)))

;---------------HELPER FUNCTIONS FOR EXTRACTING RESULT LIST--------------------

(: get-results : String -> (Listof (Listof String)))
;; extracts only lines beginning with "result:" from a file and splits them
;; appropriately
(define (get-results file)
  (map (λ ([s : String]) (split #\| s))
  (map (λ ([li : (Listof String)]) (list-ref li 1))
        (filter (λ ([l : (Listof String)]) (string=? "result" (list-ref l 0)))
   (map (λ ([s : String]) (split #\: s)) (file->lines file))))))

(define-struct LanePair
  ([lane : Int]
   [lanedata : (Listof String)]))

(: make-lanepairs : (Listof (Listof String)) -> (Listof LanePair))
;; takes a get-results output and turns it into a LanePair list
(define (make-lanepairs unsortedresults)
  (local
    {(: make-lanepair : (Listof String) -> LanePair)
     ;; takes an element of a get-result output and configures it
     ;;into a LanePair
     (define (make-lanepair rstrings)
       (LanePair
        (cast (string->number (list-ref rstrings 0)) Int)
        (drop 1 rstrings)))}
    (map (λ ([ls : (Listof String)])
           (make-lanepair ls)) unsortedresults)))

(: sort-lanepairs : (Listof LanePair) -> (Listof LanePair))
;; puts the lane pairs in the correct order
(define (sort-lanepairs lplist)
  (local
    {(: lane-higher? : LanePair LanePair -> Bool)
     ;; checks if the lane in the first pair is a lower value than the second
     (define (lane-higher? lp1 lp2)
       (match* (lp1 lp2)
       [((LanePair lane1 _) (LanePair lane2 _))
        (< lane1 lane2)]))}
    (quick-sort lplist lane-higher?)))

(: de-lanepair : (Listof LanePair) -> (Listof (Listof String)))
;; extracts the lanedata from a sorted LanePair list
(define (de-lanepair slplist)
  (map (λ ([lp : LanePair])
         (match lp
           [(LanePair _ lanedata) lanedata])) slplist))

(: make-sorted-str-results : String -> (Listof (Listof String)))
;; notational condensation of above process (taking file name and producing
;; sorted string list of result by lane)
(define (make-sorted-str-results file)
  (de-lanepair (sort-lanepairs (make-lanepairs (get-results file)))))

(: get-swimmer : (Listof String) -> Swimmer)
;; takes a sublist from a make-sorted-str-results output and constructs the
;; swimmer from the data
(define (get-swimmer data)
  (Swimmer
   (list-ref data 0)
   (list-ref data 1)
   (cast (string->symbol (list-ref data 2)) Country)
   (cast (string->number (list-ref data 3)) Real)))

(: grab-splits : (Listof String) -> (Listof Real))
;; takes a sublist from a make-sorted-str-results output and constructs the
;; splits list from the data
(define (grab-splits data)
  (local
    {(: split-splits : (Listof String) -> (Listof String))
     ;; takes a line of sorted string results and creates a list of the splits
     ;; as strings
     (define (split-splits line)
       (split #\, (list-ref line 4)))}
  (map (λ ([s : String]) (cast (string->number s) Real)) (split-splits data))))


(: get-pool : String -> (Listof Result))
;; extracts the result list from the file
(define (get-pool file)
  (local
    {(: get-result : (Listof String) -> Result)
     ;; takes a sublist from a make-sorted-str-results output and constructs
     ;; the result from the data
     (define (get-result data)
       (Result (get-swimmer data) (grab-splits data)))}
    (map (λ ([ls : (Listof String)])
           (get-result ls))
         (make-sorted-str-results file))))                    

(: sim-from-file : TickInterval Integer String -> Sim)
;; given a tick interval, a pixels-per-meter, and the name of an swm file,
;; build a Sim that contains the data from the file
;; - note: the Sim constructed by this function should contain 'None
;;         in the file-chooser slot
;; - note: GIGO applies to this function in all ways
(define (sim-from-file tickinterval ppm file)
  (local
    {(define pool (get-pool file))}
  (Sim 'paused (get-event file) tickinterval '1x 0 ppm pool
       (create-label pool ppm) (create-rank-list pool) (get-etime pool) 'None)))

(define alphabet '(#\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m #\n #\o
                       #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z))

(: get-files : String String -> (Listof String))
;; given a suffix and directory, retrieves all files in that directory
;; with the given suffix, as strings
(define (get-files suffix dir)
  (map (λ ([ls : (Listof String)])
         (string-append (list-ref ls 0) "." (list-ref ls 1)))
   (filter (λ ([ls : (Listof String)])
            (string=? suffix (list-ref ls 1)))
   (map (λ ([s : String]) (split #\. s))
        (map path->string (directory-list dir))))))

(: build-assoc : (Listof String) (Listof Char) Int
   -> (Listof (KeyValue Char String)))
;; given a get-files output and a char list of equal length,
;; produces a list of KeyValues assigning characters sequentially to each value
(define (build-assoc filelist charlist acc)
    (match filelist
      ['() '()]
      [(cons first rest)
       (cons (KeyValue (list-ref charlist acc) first)
             (build-assoc rest charlist (add1 acc)))]))

(: build-file-chooser : String String -> FileChooser)
;; given a suffix and a directory name, build a file chooser
;; associating the characters a, b, c, etc. with all the files
;; in the given directory that have the given suffix
;; - note: you don't need to support more than 26 files
;;         (which would exhaust the alphabet) -- consider that
;;         GIGO if it happens
(define (build-file-chooser suffix dirname)
  (local
    {(define filelist (get-files suffix dirname))}
  (FileChooser dirname
               (Association char=? (build-assoc filelist
                             (take (length filelist) alphabet) 0)))))

(: reset : Sim -> Sim)
;; reset the simulation to the beginning of the race
(define (reset sim)
  (match sim
    [(Sim mode event tickrate speed _ ppm pool labels ranks etime filechooser)
     (Sim 'paused event tickrate speed 0 ppm pool
          labels ranks etime filechooser)]))

(: set-mode : Mode Sim -> Sim)
;; set the mode in simulation
(define (set-mode newmode sim)
  (match sim
    [(Sim _ event tickinterval speed clock ppm pool labels ranks
          etime filechooser)
     (Sim newmode event tickinterval speed clock ppm pool labels ranks
          etime filechooser)]))

(: set-speed : (U '1x '2x '4x '8x) Sim -> Sim)
;; set the simulation speed
(define (set-speed newspeed sim)
  (match sim
    [(Sim mode event tickinterval _ clock ppm pool labels ranks
          etime filechooser)
     (Sim mode event tickinterval newspeed clock ppm pool labels ranks
          etime filechooser)]))

(: toggle-paused : Sim -> Sim)
;; set 'running sim to 'paused, and set 'paused sim to 'running
;; return 'done or 'choose sim as is
(define (toggle-paused sim)
  (match sim
    [(Sim 'done _ _ _ _ _ _ _ _ _ _) sim]
    [(Sim 'choose  _ _ _ _ _ _ _ _ _ _) sim]
    [(Sim 'running event tickinterval speed clock ppm pool labels ranks
          etime filechooser)
     (Sim 'paused event tickinterval speed clock ppm pool labels ranks
          etime filechooser)]
    [(Sim 'paused event tickinterval speed clock ppm pool labels ranks
          etime filechooser)
     (Sim 'running event tickinterval speed clock ppm pool labels ranks
          etime filechooser)]))

(: sim-from-file-fc : TickInterval Integer (Optional FileChooser) String -> Sim)
;; stashes the filechooser from the 'choose screen before running sim-from-file
(define (sim-from-file-fc tickinterval ppm filechooser file)
  (local
    {(define pool (get-pool file))}
  (Sim 'paused (get-event file) tickinterval '1x 0 ppm pool
       (create-label pool ppm) (create-rank-list pool)
       (get-etime pool) filechooser)))
     

(: react-to-keyboard : Sim String -> Sim)
;; set sim-speed to 1x, 2x, or 4x on "1", "2", "4"
;; reset the simulation on "r"
;; if in 'choose mode, load the proper race on the correct key hit
(define (react-to-keyboard sim k)
  (match sim
    [(Sim mode event tickinterval speed clock ppm pool labels ranks
          etime filechooser)
     (if (symbol=? mode 'choose)
         (local
           {(define assoc?
              (match filechooser
                ['None 'None]
                [(Some (FileChooser _ assoclist))
                 (find-assoc
                  (list-ref (string->list k) 0) assoclist)]))}
           (match assoc?
             ['None sim]
             [(Some s)
              (sim-from-file-fc tickinterval ppm filechooser
                             (string-append (match filechooser
                                              [(Some (FileChooser dir _))
                                               (string-append dir "/"
                                                              s)])))]))
         (match k
           ["1" (set-speed '1x sim)]
           ["2" (set-speed '2x sim)]
           ["4" (set-speed '4x sim)]
           ["8" (set-speed '8x sim)]
           ["r" (reset sim)]
           ["d"
            (Sim 'choose (Event 'Men 50 'Freestyle "Null" (Date 9 9 9999))
                 tickinterval '1x 0 ppm
                 (list (Result (Swimmer "Null" "Null" 'USA 1.00) '(99.99)))
                 empty-image '(0) 99.99 filechooser)]
           [_ sim]))]))

(: react-to-tick : Sim -> Sim)
;; if simulation is 'running, increase sim-clock accordingly
;; - note: the amount of time added to sim-clock depends on
;; sim-speed and tick-rate
(define (react-to-tick sim)
  (match sim
    [(Sim 'paused _ _ _ _ _ _ _ _ _ _) sim]
    [(Sim 'done _ _ _ _ _ _ _ _ _ _) sim]
    [(Sim 'choose _ _ _ _ _ _ _ _ _ _) sim]
    [(Sim 'running event tickrate speed clock ppm pool labels ranks
          etime filechooser)
     (if (andmap (λ ([r : Result]) (done? clock r)) pool)
      (Sim 'done event tickrate speed clock ppm pool labels ranks
           etime filechooser)
     (match speed
       ['1x (Sim 'running event tickrate speed
                   (+ clock tickrate) ppm pool labels ranks etime filechooser)]
       ['2x (Sim 'running event tickrate speed (+ clock (* 2 tickrate)) ppm
                 pool labels ranks etime filechooser)]
       ['4x (Sim 'running event tickrate speed (+ clock (* 4 tickrate)) ppm
                 pool labels ranks etime filechooser)]
       ['8x (Sim 'running event tickrate speed (+ clock (* 8 tickrate)) ppm
                 pool labels ranks etime filechooser)]))]))

(: react-to-mouse : Sim Integer Integer Mouse-Event -> Sim)
;; pause/unpause the simulation on "button-down"
(define (react-to-mouse sim x y me)
  (match sim
    [(Sim 'done _ _ _ _ _ _ _ _ _ _) sim]
    [(Sim 'choose _ _ _ _ _ _ _ _ _ _) sim]
    [(Sim 'running event tickrate speed clock ppm pool labels ranks
          etime filechooser)
     (match me
       ["button-down"
        (Sim 'paused event tickrate speed clock ppm pool labels ranks
             etime filechooser)]
       [_ sim])]
    [(Sim 'paused event tickrate speed clock ppm pool labels ranks
          etime filechooser)
     (match me
       ["button-down"
        (Sim 'running event tickrate speed clock ppm pool labels ranks
             etime filechooser)]
       [_ sim])]))

(: draw-choice : (KeyValue Char String) -> Image)
;; Given an element of an association, draws a choice box for the 'choose screen
(define (draw-choice keyval)
  (match keyval
    [(KeyValue c str)
     (above
      (place-image
       (overlay/align 'center 'center
                      (text (string c) 30 'blue)
                      (circle 18 'solid 'white))
       (* 2 (string-length str)) 20
       (overlay/align 'right 'middle
                      (text str 30 'black)
                      (rectangle (* 22 (string-length str)) 40
                                 'solid "paleturquoise")))
      (rectangle 1 10 'solid 'white))]))

(: draw : Sim -> Image)
;; draw the simulation in its current state, including
;; both graphical and textual elements
(define (draw sim)
  (match sim
    [(Sim mode event tickinterval speed clock ppm pool labels ranks
          etime filechooser)
     (cond
       [(symbol=? mode 'done)
         (above
          (frame (beside
                  (above
                   (rectangle (* 50 ppm) (* 2.5 ppm) 'solid 'lightblue)
                   (rectangle (* 50 ppm) (* 0.25 ppm) 'solid 'black)
                   (draw-lanes-result (length pool) 0 ppm pool ranks)
                   (rectangle (* 50 ppm) (* 2.5 ppm) 'solid 'lightblue))
                  labels))
         (text (string-append
                "Current Simulation Time: "
                (mmsshh etime)) 15 'black)
         (text "Press r to reset race, or d to return to directory" 15 'black))]
       [(symbol=? mode 'choose)
        (overlay/align 'left 'top
         (above
         (text
          (string-append "Current Directory: " (match filechooser
                 [(Some (FileChooser dir _)) dir])) 20 'black)
         (match filechooser
           [(Some (FileChooser _ assoclist))
            (match assoclist
              [(Association key=? data)
            (foldl above empty-image
                (map (λ ([kv : (KeyValue Char String)])
                       (draw-choice kv)) (reverse data)))])]))
         (rectangle (+ (* 50 ppm) (* 20 ppm)) (* 30 ppm) 'solid 'white))]
       [else
        (above
         (frame (beside
                 (above
                  (rectangle (* 50 ppm) (* 2.5 ppm) 'solid 'lightblue)
                  (rectangle (* 50 ppm) (* 0.25 ppm) 'solid 'black)
                  (foldl above empty-image
                         (map (λ [(r : Result)] (draw-lane ppm r clock))
                              (reverse pool)))
                  (rectangle (* 50 ppm) (* 2.5 ppm) 'solid 'lightblue)) labels))
         (text (string-append "Current Simulation Time: "
                              (if (andmap (λ ([r : Result])
                                            (done? clock r)) pool)
                                  (mmsshh etime)
                                  (mmsshh (get-clock sim)))) 15 'black)
         (text (string-append "Playback Rate: "
                              (symbol->string (get-speed sim))) 15 'maroon)
         (text
          "Press r to reset race, or d to return to directory" 15 'black))])]))

(: initial-sim : TickInterval Integer String -> Sim)
;; builds the choose screen on initial application startup with inputs
;; tick interval, pixels per meter, and directory path
(define (initial-sim tickinterval ppm dir)
  (Sim 'choose (Event 'Men 50 'Freestyle "Null" (Date 9 9 9999))
         tickinterval '1x 0 ppm
         (list (Result (Swimmer "Null" "Null" 'USA 1.00) '(99.99)))
         empty-image '(0) 99.99 (Some (build-file-chooser "swm" dir))))

(: run : TickInterval Integer String -> Sim)
;; the run function should consume a tick interval, a pixels per meter,
;; and a path to a directory containing one or more .swm files
(define (run tickinterval ppm dir)
  (big-bang (initial-sim tickinterval ppm dir) : Sim
    [name dir]
    [to-draw draw]
    [on-mouse react-to-mouse]
    [on-key react-to-keyboard]
    [on-tick react-to-tick tickinterval]))