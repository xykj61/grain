# tools/fixtures/entity_journal_truth.awk — an independent measurement of a Dimeroll journal fixture.
#
# GISM-AYRE-J8r4's witness cross-checks what entity_books_true's fold reports against this awk's
# reading of the same real bytes — two tools, one answer — so an entity's balance can never drift
# from facts a keeper can add up by hand. It counts entries (one per `amount` line), sums the
# amounts, and computes the debit-positive cash net (cash debits raise it, cash credits lower it).
# Comment (`#`) and separator (`---`) lines carry no debit/credit/amount key and are ignored.
#
#   awk -f tools/fixtures/entity_journal_truth.awk dimeroll/fixtures/journal.bron
#   -> "<entries> <amount_sum> <cash_net>"

/^debit /  { blk_debit = $2 }
/^credit / { blk_credit = $2 }
/^amount / { amt = $2; sum += amt; n += 1; if (blk_debit == "cash") cash += amt; if (blk_credit == "cash") cash -= amt }
END        { print n, sum, cash }
