#' Filter TCGA Replicate Sample Barcodes
#'
#' Check details for filter rules.
#'
#' In many instances there is more than one aliquot for a given combination of individual, platform, and data type. However, only one aliquot may be ingested into Firehose. Therefore, a set of precedence rules are applied to select the most scientifically advantageous one among them. Two filters are applied to achieve this aim: an Analyte Replicate Filter and a Sort Replicate Filter.
#'
#' ### Analyte Replicate Filter
#'
#' The following precedence rules are applied when the aliquots have differing analytes. For RNA aliquots, T analytes are dropped in preference to H and R analytes, since T is the inferior extraction protocol. If H and R are encountered, H is the chosen analyte. This is somewhat arbitrary and subject to change, since it is not clear at present whether H or R is the better protocol. If there are multiple aliquots associated with the chosen RNA analyte, the aliquot with the later plate number is chosen. For DNA aliquots, D analytes (native DNA) are preferred over G, W, or X (whole-genome amplified) analytes, unless the G, W, or X analyte sample has a higher plate number.
#'
#' ### Sort Replicate Filter
#'
#' The following precedence rules are applied when the analyte filter still produces more than one sample. The sort filter chooses the aliquot with the highest lexicographical sort value, to ensure that the barcode with the highest portion and/or plate number is selected when all other barcode fields are identical.
#'
#' **NOTE**: Basically, user provides tsb and analyte_target is fine.
#'
#' @param tsb a vector of TCGA sample barcodes.
#' @param analyte_target type of barcodes, "DNA" or "RNA".
#' @param decreasing if `TRUE` (default), use decreasing order to select barcode to keep.
#' @param analyte_position bit position for analyte. DON'T CHANGE IT if you don't understand.
#' @param plate bit position for plate. DON'T CHANGE IT if you don't understand.
#' @param portion bit position for portion. DON'T CHANGE IT if you don't understand.
#' @param filter_FFPE if `TRUE` (`FALSE` is default), filter out FFPE samples.
#' @references
#' Rules:
#'
#' - `https://confluence.broadinstitute.org/display/GDAC/FAQ#FAQ-sampleTypesQWhatTCGAsampletypesareFirehosepipelinesexecutedupon`
#'
#' FFPE cases:
#'
#' - `http://gdac.broadinstitute.org/runs/sampleReports/latest/FPPP_FFPE_Cases.html`
#'
#' @return a barcode list.
#' @export
#'
#' @examples
#' filter_tcga_barcodes(c("TCGA-44-2656-01B-06D-A271-08", "TCGA-44-2656-01B-06D-A273-01"))
#' filter_tcga_barcodes(c("TCGA-44-2656-01B-06D-A271-08", "TCGA-44-2656-01B-06D-A273-01"),
#'   filter_FFPE = TRUE
#' )
filter_tcga_barcodes <- function(tsb, analyte_target = c("DNA", "RNA"),
                                 decreasing = TRUE, analyte_position = 20, plate = c(22, 25),
                                 portion = c(18, 19), filter_FFPE = FALSE) {
  analyte_target <- match.arg(analyte_target)
  # Strings in R are largely lexicographic
  # see ??base::Comparison

  if (any(nchar(tsb) == 28L) & filter_FFPE) {
    ffpe <- c(
      "TCGA-44-2656-01B-06D-A271-08", "TCGA-44-2656-01B-06D-A273-01",
      "TCGA-44-2656-01B-06D-A276-05", "TCGA-44-2656-01B-06D-A27C-26",
      "TCGA-44-2656-01B-06R-A277-07", "TCGA-44-2662-01B-02D-A271-08",
      "TCGA-44-2662-01B-02D-A273-01", "TCGA-44-2662-01B-02R-A277-07",
      "TCGA-44-2665-01B-06D-A271-08", "TCGA-44-2665-01B-06D-A273-01",
      "TCGA-44-2665-01B-06D-A276-05", "TCGA-44-2665-01B-06R-A277-07",
      "TCGA-44-2666-01B-02D-A271-08", "TCGA-44-2666-01B-02D-A273-01",
      "TCGA-44-2666-01B-02D-A276-05", "TCGA-44-2666-01B-02D-A27C-26",
      "TCGA-44-2666-01B-02R-A277-07", "TCGA-44-2668-01B-02D-A271-08",
      "TCGA-44-2668-01B-02D-A273-01", "TCGA-44-2668-01B-02D-A276-05",
      "TCGA-44-2668-01B-02D-A27C-26", "TCGA-44-2668-01B-02R-A277-07",
      "TCGA-44-3917-01B-02D-A271-08", "TCGA-44-3917-01B-02D-A273-01",
      "TCGA-44-3917-01B-02D-A276-05", "TCGA-44-3917-01B-02D-A27C-26",
      "TCGA-44-3917-01B-02R-A277-07", "TCGA-44-3918-01B-02D-A271-08",
      "TCGA-44-3918-01B-02D-A273-01", "TCGA-44-3918-01B-02D-A276-05",
      "TCGA-44-3918-01B-02D-A27C-26", "TCGA-44-3918-01B-02R-A277-07",
      "TCGA-44-4112-01B-06D-A271-08", "TCGA-44-4112-01B-06D-A273-01",
      "TCGA-44-4112-01B-06D-A276-05", "TCGA-44-4112-01B-06D-A27C-26",
      "TCGA-44-4112-01B-06R-A277-07", "TCGA-44-5645-01B-04D-A271-08",
      "TCGA-44-5645-01B-04D-A273-01", "TCGA-44-5645-01B-04D-A276-05",
      "TCGA-44-5645-01B-04D-A27C-26", "TCGA-44-5645-01B-04R-A277-07",
      "TCGA-44-6146-01B-04D-A271-08", "TCGA-44-6146-01B-04D-A273-01",
      "TCGA-44-6146-01B-04D-A276-05", "TCGA-44-6146-01B-04D-A27C-26",
      "TCGA-44-6146-01B-04R-A277-07", "TCGA-44-6146-01B-04R-A27D-13",
      "TCGA-44-6147-01B-06D-A271-08", "TCGA-44-6147-01B-06D-A273-01",
      "TCGA-44-6147-01B-06D-A276-05", "TCGA-44-6147-01B-06D-A27C-26",
      "TCGA-44-6147-01B-06R-A277-07", "TCGA-44-6147-01B-06R-A27D-13",
      "TCGA-44-6775-01C-02D-A271-08", "TCGA-44-6775-01C-02D-A273-01",
      "TCGA-44-6775-01C-02D-A276-05", "TCGA-44-6775-01C-02D-A27C-26",
      "TCGA-44-6775-01C-02R-A277-07", "TCGA-44-6775-01C-02R-A27D-13",
      "TCGA-A6-2674-01B-04D-A270-10", "TCGA-A6-2674-01B-04R-A277-07",
      "TCGA-A6-2677-01B-02D-A270-10", "TCGA-A6-2677-01B-02D-A274-01",
      "TCGA-A6-2677-01B-02D-A27A-05", "TCGA-A6-2677-01B-02D-A27E-26",
      "TCGA-A6-2677-01B-02R-A277-07", "TCGA-A6-2684-01C-08D-A270-10",
      "TCGA-A6-2684-01C-08D-A274-01", "TCGA-A6-2684-01C-08D-A27A-05",
      "TCGA-A6-2684-01C-08D-A27E-26", "TCGA-A6-2684-01C-08R-A277-07",
      "TCGA-A6-3809-01B-04D-A270-10", "TCGA-A6-3809-01B-04D-A274-01",
      "TCGA-A6-3809-01B-04D-A27A-05", "TCGA-A6-3809-01B-04D-A27E-26",
      "TCGA-A6-3809-01B-04R-A277-07", "TCGA-A6-3810-01B-04D-A270-10",
      "TCGA-A6-3810-01B-04D-A274-01", "TCGA-A6-3810-01B-04D-A27A-05",
      "TCGA-A6-3810-01B-04D-A27E-26", "TCGA-A6-3810-01B-04R-A277-07",
      "TCGA-A6-5656-01B-02D-A270-10", "TCGA-A6-5656-01B-02D-A274-01",
      "TCGA-A6-5656-01B-02D-A27A-05", "TCGA-A6-5656-01B-02D-A27E-26",
      "TCGA-A6-5656-01B-02R-A277-07", "TCGA-A6-5656-01B-02R-A27D-13",
      "TCGA-A6-5659-01B-04D-A270-10", "TCGA-A6-5659-01B-04D-A274-01",
      "TCGA-A6-5659-01B-04D-A27A-05", "TCGA-A6-5659-01B-04D-A27E-26",
      "TCGA-A6-5659-01B-04R-A277-07", "TCGA-A6-6650-01B-02D-A270-10",
      "TCGA-A6-6650-01B-02D-A274-01", "TCGA-A6-6650-01B-02D-A27A-05",
      "TCGA-A6-6650-01B-02D-A27E-26", "TCGA-A6-6650-01B-02R-A277-07",
      "TCGA-A6-6650-01B-02R-A27D-13", "TCGA-A6-6780-01B-04D-A270-10",
      "TCGA-A6-6780-01B-04D-A274-01", "TCGA-A6-6780-01B-04D-A27A-05",
      "TCGA-A6-6780-01B-04D-A27E-26", "TCGA-A6-6780-01B-04R-A277-07",
      "TCGA-A6-6780-01B-04R-A27D-13", "TCGA-A6-6781-01B-06D-A270-10",
      "TCGA-A6-6781-01B-06D-A274-01", "TCGA-A6-6781-01B-06D-A27A-05",
      "TCGA-A6-6781-01B-06R-A277-07", "TCGA-A6-6781-01B-06R-A27D-13",
      "TCGA-A7-A0DB-01C-02D-A272-09", "TCGA-A7-A0DB-01C-02R-A277-07",
      "TCGA-A7-A0DB-01C-02R-A27D-13", "TCGA-A7-A13D-01B-04D-A272-09",
      "TCGA-A7-A13D-01B-04R-A277-07", "TCGA-A7-A13D-01B-04R-A27D-13",
      "TCGA-A7-A13E-01B-06D-A272-09", "TCGA-A7-A13E-01B-06R-A277-07",
      "TCGA-A7-A13E-01B-06R-A27D-13", "TCGA-A7-A26E-01B-06D-A272-09",
      "TCGA-A7-A26E-01B-06D-A275-01", "TCGA-A7-A26E-01B-06D-A27B-05",
      "TCGA-A7-A26E-01B-06R-A277-07", "TCGA-A7-A26E-01B-06R-A27D-13",
      "TCGA-A7-A26J-01B-02D-A272-09", "TCGA-A7-A26J-01B-02D-A275-01",
      "TCGA-A7-A26J-01B-02D-A27B-05", "TCGA-A7-A26J-01B-02D-A27F-26",
      "TCGA-A7-A26J-01B-02R-A277-07", "TCGA-A7-A26J-01B-02R-A27D-13",
      "TCGA-B2-3923-01B-10D-A270-10", "TCGA-B2-3923-01B-10R-A277-07",
      "TCGA-B2-3923-01B-10R-A27D-13", "TCGA-B2-3924-01B-03D-A270-10",
      "TCGA-B2-3924-01B-03D-A274-01", "TCGA-B2-3924-01B-03D-A27A-05",
      "TCGA-B2-3924-01B-03D-A27E-26", "TCGA-B2-3924-01B-03R-A277-07",
      "TCGA-B2-3924-01B-03R-A27D-13", "TCGA-B2-5633-01B-04D-A270-10",
      "TCGA-B2-5633-01B-04D-A274-01", "TCGA-B2-5633-01B-04D-A27A-05",
      "TCGA-B2-5633-01B-04D-A27E-26", "TCGA-B2-5633-01B-04R-A277-07",
      "TCGA-B2-5633-01B-04R-A27D-13", "TCGA-B2-5635-01B-04D-A270-10",
      "TCGA-B2-5635-01B-04D-A274-01", "TCGA-B2-5635-01B-04D-A27A-05",
      "TCGA-B2-5635-01B-04D-A27E-26", "TCGA-B2-5635-01B-04R-A277-07",
      "TCGA-B2-5635-01B-04R-A27D-13", "TCGA-BK-A0CA-01B-02D-A272-09",
      "TCGA-BK-A0CA-01B-02D-A275-01", "TCGA-BK-A0CA-01B-02D-A27B-05",
      "TCGA-BK-A0CA-01B-02D-A27F-26", "TCGA-BK-A0CA-01B-02R-A277-07",
      "TCGA-BK-A0CA-01B-02R-A27D-13", "TCGA-BK-A0CC-01B-04D-A272-09",
      "TCGA-BK-A0CC-01B-04D-A275-01", "TCGA-BK-A0CC-01B-04D-A27B-05",
      "TCGA-BK-A0CC-01B-04R-A277-07", "TCGA-BK-A0CC-01B-04R-A27D-13",
      "TCGA-BK-A139-01C-08D-A272-09", "TCGA-BK-A139-01C-08D-A275-01",
      "TCGA-BK-A139-01C-08D-A27B-05", "TCGA-BK-A139-01C-08D-A27F-26",
      "TCGA-BK-A139-01C-08R-A277-07", "TCGA-BK-A139-01C-08R-A27D-13",
      "TCGA-BK-A26L-01C-04D-A272-09", "TCGA-BK-A26L-01C-04D-A275-01",
      "TCGA-BK-A26L-01C-04D-A27B-05", "TCGA-BK-A26L-01C-04D-A27F-26",
      "TCGA-BK-A26L-01C-04R-A277-07", "TCGA-BK-A26L-01C-04R-A27D-13",
      "TCGA-BL-A0C8-01B-04D-A271-08", "TCGA-BL-A0C8-01B-04D-A273-01",
      "TCGA-BL-A0C8-01B-04D-A276-05", "TCGA-BL-A0C8-01B-04D-A27C-26",
      "TCGA-BL-A0C8-01B-04R-A277-07", "TCGA-BL-A0C8-01B-04R-A27D-13",
      "TCGA-BL-A13I-01B-04D-A271-08", "TCGA-BL-A13I-01B-04D-A276-05",
      "TCGA-BL-A13I-01B-04R-A277-07", "TCGA-BL-A13I-01B-04R-A27D-13",
      "TCGA-BL-A13J-01B-04D-A271-08", "TCGA-BL-A13J-01B-04D-A273-01",
      "TCGA-BL-A13J-01B-04D-A276-05", "TCGA-BL-A13J-01B-04D-A27C-26",
      "TCGA-BL-A13J-01B-04R-A277-07", "TCGA-BL-A13J-01B-04R-A27D-13"
    )

    tsb <- setdiff(tsb, tsb[tsb %in% ffpe])
  }

  # find repeated samples
  sampleID <- substr(tsb, start = 1, stop = 15)
  dp_samples <- unique(sampleID[duplicated(sampleID)])

  if (length(dp_samples) == 0) {
    message("ooo Not find any duplicated barcodes, return..")
    tsb
  } else {
    uniq_tsb <- tsb[!sampleID %in% dp_samples]
    dp_tsb <- setdiff(tsb, uniq_tsb)

    add_tsb <- c()

    # analyte = substr(dp_tsb, start = analyte_position, stop = analyte_position)
    # if analyte_target = "DNA"
    # analyte:  D > G,W,X
    if (analyte_target == "DNA") {
      for (x in dp_samples) {
        mulaliquots <- dp_tsb[substr(dp_tsb, 1, 15) == x]
        analytes <- substr(mulaliquots,
          start = analyte_position,
          stop = analyte_position
        )
        if (any(analytes == "D") & !(all(analytes == "D"))) {
          aliquot <- mulaliquots[analytes == "D"]

          if (length(aliquot) != 1) {
            # Still have repeats
            # Remove the samples and add repeated id back to list
            dp_tsb <- c(setdiff(dp_tsb, mulaliquots), aliquot)
          } else {
            # If have no repeats
            # Just remove samples from list and
            # add unique id to result list
            add_tsb <- c(add_tsb, aliquot)
            dp_tsb <- setdiff(dp_tsb, mulaliquots)
          }
        }
      }
    } else {
      # if analyte_target = "RNA"
      # analyte: H > R > T
      for (x in dp_samples) {
        mulaliquots <- dp_tsb[substr(dp_tsb, 1, 15) == x]
        analytes <- substr(mulaliquots,
          start = analyte_position,
          stop = analyte_position
        )
        if (any(analytes == "H") & !(all(analytes == "H"))) {
          aliquot <- mulaliquots[analytes == "H"]

          if (length(aliquot) != 1) {
            # Still have repeats
            # Remove the samples and add repeated id back to list
            dp_tsb <- c(setdiff(dp_tsb, mulaliquots), aliquot)
          } else {
            # If have no repeats
            # Just remove samples from list and
            # add unique id to result list
            add_tsb <- c(add_tsb, aliquot)
            dp_tsb <- setdiff(dp_tsb, mulaliquots)
          }
        } else if (any(analytes == "R") & !(all(analytes == "R"))) {
          aliquot <- mulaliquots[analytes == "R"]

          if (length(aliquot) != 1) {
            # Still have repeats
            # Remove the samples and add repeated id back to list
            dp_tsb <- c(setdiff(dp_tsb, mulaliquots), aliquot)
          } else {
            # If have no repeats
            # Just remove samples from list and
            # add unique id to result list
            add_tsb <- c(add_tsb, aliquot)
            dp_tsb <- setdiff(dp_tsb, mulaliquots)
          }
        } else if (any(analytes == "T") & !(all(analytes == "T"))) {
          aliquot <- mulaliquots[analytes == "T"]

          if (length(aliquot) != 1) {
            # Still have repeats
            # Remove the samples and add repeated id back to list
            dp_tsb <- c(setdiff(dp_tsb, mulaliquots), aliquot)
          } else {
            # If have no repeats
            # Just remove samples from list and
            # add unique id to result list
            add_tsb <- c(add_tsb, aliquot)
            dp_tsb <- setdiff(dp_tsb, mulaliquots)
          }
        }
      }
    }


    if (length(dp_tsb) == 0) {
      message("ooo Filter barcodes successfully!")
      c(uniq_tsb, add_tsb)
    } else {
      # filter according to portion number
      sampleID_res <- substr(dp_tsb, start = 1, stop = 15)
      dp_samples_res <- unique(sampleID_res[duplicated(sampleID_res)])

      for (x in dp_samples_res) {
        mulaliquots <- dp_tsb[substr(dp_tsb, 1, 15) == x]
        portion_codes <- substr(mulaliquots,
          start = portion[1],
          stop = portion[2]
        )
        portion_keep <- sort(portion_codes, decreasing = decreasing)[1]
        if (!all(portion_codes == portion_keep)) {
          if (sum(portion_codes == portion_keep) == 1) {
            add_tsb <- c(add_tsb, mulaliquots[portion_codes == portion_keep])
            dp_tsb <- setdiff(dp_tsb, mulaliquots)
          } else {
            dp_tsb <- setdiff(dp_tsb, mulaliquots[portion_codes != portion_keep])
          }
        }
      }

      if (length(dp_tsb) == 0) {
        message("ooo Filter barcodes successfully!")
        c(uniq_tsb, add_tsb)
      } else {
        # filter according to plate number
        sampleID_res <- substr(dp_tsb, start = 1, stop = 15)
        dp_samples_res <- unique(sampleID_res[duplicated(sampleID_res)])
        for (x in dp_samples_res) {
          mulaliquots <- dp_tsb[substr(dp_tsb, 1, 15) == x]
          plate_codes <- substr(mulaliquots,
            start = plate[1],
            stop = plate[2]
          )
          plate_keep <- sort(plate_codes, decreasing = decreasing)[1]
          add_tsb <- c(add_tsb, sort(mulaliquots[plate_codes == plate_keep])[1])
          dp_tsb <- setdiff(dp_tsb, mulaliquots)
        }

        if (length(dp_tsb) == 0) {
          message("ooo Filter barcodes successfully!")
          c(uniq_tsb, add_tsb)
        } else {
          message("ooo barcodes ", dp_tsb, " failed in filter process, other barcodes will be returned.")
          c(uniq_tsb, add_tsb)
        }
      }
    }
  }
}
