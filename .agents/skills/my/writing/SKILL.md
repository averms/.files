---
name: writing
description: >-
  Rules for writing English in and around code — code comments, docstrings, READMEs,
  design docs, Markdown guides, commit messages, PR descriptions, error messages, and
  review notes. Use when asked to "clean up the docs", "de-AI" text, or "deslopify",
  and when reviewing prose someone else wrote.
---

How to write English that another person can rely on: comments, docs, commit messages, PR text,
error messages. The recurring failure in machine-written prose is that it is smooth, long, and
low-signal. It narrates instead of explaining, hedges instead of committing, and restates what the
reader can already see. This skill is about writing less, saying more, and only saying what is true.

The reader is the unit of optimization. Every rule below exists because it lowers the cost for a
future reader (human or agent) to make a correct decision without re-deriving context.

## Contents

1. Core stance
2. Code comments
3. Docstrings and API docs
4. Documents (READMEs, guides, design docs)
5. Sentence and paragraph craft
6. Generated-prose tells to cut
7. Commit messages, PR descriptions, and handoffs
8. Error messages
9. Revising existing prose
10. Before handing off

## 1. Core stance

**Prose near code is a contract.** A comment, docstring, or README example is a statement of intended
behavior that readers will implement against, file bugs against, and preserve. If it is wrong, it is
a bug. This has two consequences:

- When you change behavior, the nearby prose is part of the change. Update it in the same edit or
  say explicitly that it is now stale.
- Describe what the code does *now*. Roadmap, intent, and "should eventually" belong in a clearly
  labeled place (an issue, a TODO with a reason, a design doc), never mixed into a sentence a reader
  will take as current fact.

**Match claim strength to evidence.** "This is thread-safe" and "I believe this is thread-safe
because the only shared state is the atomic counter" are different claims. Say which one you are
making. If you did not run it, do not write as though you did.

**Concrete beats abstract.** Name the command, the path, the type, the default value, the actor.
"Configuration is loaded" hides who loads it, from where, and when. "`main()` reads `config.toml`
from the working directory before opening the database" answers all three.

**Don't invent intent.** If you cannot tell why code has the shape it has, do not write a plausible
reason. Say nothing, or write `// Unclear why this is retried twice; see git blame` and move on. A
confident wrong comment is worse than no comment.

## 2. Code comments

The test for every comment: **does it tell the reader something they could not get from the code in
front of them?** If the answer is no, delete it.

### Delete comments that restate the code

```python
# Increment the retry count
retry_count += 1

# Loop over the users
for user in users:

# Return the result
return result
```

These make the file longer, train the reader to skip comments, and drift the moment the code changes.
Variable names, function names, and types already carry this information.

### Keep comments that carry what code cannot

Code shows *what*; comments are for *why*, *what must hold*, and *what is surprising*:

```python
# Retry once after token refresh; further retries can replay non-idempotent requests.
retry_count += 1
```

```go
// Sort before hashing so equal sets produce equal digests regardless of insertion order.
sort.Strings(keys)
```

```ts
// The API returns 200 with an empty body on "not found"; treat that as null, not as an error.
if (resp.status === 200 && !resp.body) return null;
```

Worth a comment:

- an invariant the block relies on that isn't enforced by types
- a compatibility, security, or ordering constraint that forces a non-obvious shape
- a workaround for an external bug or quirk, with enough detail to know when it can be removed
- a domain convention that a newcomer would not infer (units, coordinate systems, sentinel values)
- why an obvious alternative was rejected

When in doubt, leave the comment out. Overcommenting is the more common and more costly failure:
it buries the few comments that matter, and every redundant line is a future drift bug. A missing
comment costs a reader a moment of thought; a stale one costs them a wrong belief.

### No section banners

Do not use comments to divide a file into regions (`# --- Helpers ---`, `// ====== Types ======`).
Structure code with modules, files, and ordering instead. Banners age badly and say nothing.

### Comment placement and shape

- Put the comment on the line(s) it explains, not at the top of the function as a paragraph of
  narration about the whole body.
- When a comment shifts register — from mechanism to history, from contract to warning — start a
  new comment paragraph (blank comment line). One continuous block hides the shift.
- Shared rationale rises to its owner: if three methods share a constraint, explain it once on the
  type or module and reference it locally.
- Don't leave process residue: `// added by AI`, `// TODO: implement`, `// as requested`, or comments
  addressed to the person who asked for the change. Comments address the future reader of the code.

### After a refactor, re-audit comments

Cleanup often makes intent obvious in the code itself. Comments that were compensating for the old
shape are now redundant; remove them. Conversely, a refactor can strand a comment next to code it no
longer describes; fix or delete it.

## 3. Docstrings and API docs

A docstring is a contract for a *caller* who has not read the body. Write for their task.

- **First sentence: what it does or returns, as an action.** `Parse a duration string like "1h30m"
  into seconds.` Not `This function is used for parsing durations.`
- **Omit it entirely if it would only restate the name.** `def get_user(id)` with `"""Get the
  user."""` is noise. Only write a docstring when it says more than the signature.
- **Prefer prose over parameter tables** unless the API is genuinely tabular. `Returns None when
  the key is absent rather than raising` is one sentence; a table for one param is ceremony.
- **State the things a signature cannot:** error and exception conditions, panics/aborts, side
  effects (writes files, sends requests, mutates input), blocking behavior, thread-safety,
  ownership/lifecycle (who closes it), valid ranges, defaults and what a default *means*, ordering
  guarantees or their absence.
- **Public fields get the same treatment as public functions:** meaning, valid values, default,
  invariants, interactions with neighboring fields.
- **Examples must be real.** An example that shows a realistic call including its error handling
  proves the contract. `foo(bar)` proves nothing. If an example cannot be run or compiled, label it
  as illustrative so nobody copy-pastes it as supported.
- **Skip docstrings on private helpers.**
- Formatting inside docstrings: minimal Markdown that reads fine raw. Code spans and simple links,
  no headings.

## 4. Documents (READMEs, guides, design docs)

### Pick the job before writing

A page can teach (tutorial), help complete a task (how-to), state exact facts (reference), or explain
why (design/explanation). Decide which one this page is, keep that mode dominant, and link out to
the others rather than blending them. A README that is half quick-start and half architecture essay
serves neither reader.

### Front-load the point

The first paragraph should give the reader the decision, command, invariant, or warning that
matters. Motivation and background come after. Readers scan; agents retrieve fragments. If the
useful sentence is fourth, both miss it.

### Prose for relationships, lists for enumeration

Use a list when the items are parallel: steps, options, fields, flags, checks. Use prose when the
point is causality, contrast, tradeoff, or judgment. Bulleting an explanation destroys the
connective tissue ("because", "unless", "which means") that made it an explanation. Bullet-heavy
drafts often hide that the reasoning was never written.

### Headings name content, not micro-points

Fewer, denser sections. A heading earns its scan cost by naming a real cluster. Avoid `Overview`,
`General`, `More details`, `Why this matters`, and runs of one-sentence sections. On reference and
landing pages use descriptive headings (`Retry policy`); reserve imperative headings (`Install the
CLI`) for procedures where the heading is genuinely a step.

### Name destinations, not directions

On navigation surfaces, name what the reader will reach — `Configuration reference`, `Deployment
runbook` — rather than telling them how to move: "start here", "use this when", "see below". Don't
narrate the page's own structure ("this page covers…", "the rest of this document…"). Explain the
system, not the document.

### READMEs are entry points

Purpose, quick start, compatibility/status, and links to deeper docs. If it takes more than a
screen to reach a working first use, move the manual-level material out. Keep maintainer depth
(release process, benchmarks, internal design) behind the first reading path.

### Keep docs near their subject

Rationale shared by several functions lives on the type; shared by several types, on the module;
cross-cutting flow, at the entry point or in a focused guide. A doc that lives far from the code it
describes drifts faster, because the person changing the code never sees it.

### Uncertainty goes somewhere tracked

Don't bury "we might change this" in user docs. Put open questions in an issue, ADR, or roadmap and
keep the user-facing text about current behavior.

### Markdown hygiene

Blank line after headings and around lists, blockquotes, and fenced blocks. Language tag on every
fence. `1.` markers for ordered lists. Aligned table columns. Follow whatever the local `rumdl`
config says over this.

## 5. Sentence and paragraph craft

**Don't give agency to things that don't act.** Categories, states, results, and labels don't
need, want, tell, decide, or require anything; people and running code do. "Broken needs a fix;
flaky needs investigation" has real verbs but fake subjects. Write who does what: "Fix broken
tests. Investigate flaky ones." The same applies to software: a `Delimiter` *specifies* where to
split a string, it doesn't *tell the splitter*; the OS *detects* a device, it doesn't *see* one.
Anthropomorphism is figurative language, and figurative language is less precise, harder to
translate, and a convenient way to sound decisive while hiding who is actually responsible.

**Give each sentence one burden.** A sentence that explains, qualifies, anticipates confusion, and
navigates at once is four sentences wearing a trench coat.

**Let a paragraph develop one idea.** Don't stack one-sentence paragraphs for rhythm; don't write
three paragraphs that restate the same point at different temperatures. Start a new paragraph when
the subject, level of detail, or type of evidence changes.

**Replace vague verbs with the real behavior.** `ensure`, `handle`, `support`, `manage`, `process`,
`deal with` hide what actually happens. "Handles errors" → "Returns `None` on missing keys and
raises `ValueError` on malformed input."

**Earn evaluative words.** `simple`, `easy`, `powerful`, `robust`, `fast`, `best`, `usually`,
`recommended` are unearned unless the sentence states the property behind them. "Fastest" →
"avoids the second network round-trip". "Simplest" → "no config file needed". If you can't name the
property, you don't have the claim.

**Keep one term per concept.** Don't rotate through near-synonyms to avoid repetition. Lexical
variety in technical prose makes the reader wonder whether `task`, `job`, and `work item` are three
things.

**Plain words over ornate ones.** `use` not `utilize` or `leverage`; `is` not `serves as` or
`represents`; `many` not `a plethora of`.

**No apology or permission phrasing** in technical text. "Just", "simply", "feel free to",
"hopefully", "sorry". They soften nothing and add length.

## 6. Generated-prose tells to cut

These patterns make text feel machine-written whether or not it was. One instance is fine;
clusters or patterns that stand in for evidence are the problem. Treat them as revision signals.

### Word choice

- Stock verbs and adjectives: `delve`, `leverage`, `utilize`, `robust`, `seamless`, `streamline`,
  `harness`, `empower`, `elevate`, `comprehensive`, `crucial`, `pivotal`.
- Ornate nouns: `landscape`, `ecosystem`, `paradigm`, `tapestry`, `synergy`, `journey`, `realm`.
- Magic adverbs that inflate ordinary facts: `deeply`, `fundamentally`, `quietly`, `remarkably`.
- Inflated copulas: `serves as`, `stands as`, `represents`, `marks` where `is` would do.

### Sentence templates

- Contrast scaffolding: `not X, but Y`; `it's not about X, it's about Y`; `X, not Y` pivots;
  `the question isn't X, it's Y`. State Y.
- Countdown negation: "Not a framework. Not a library. Just a tool." Say what it is.
- Self-answered rhetorical questions: "So what does this mean? It means…"
- Rule-of-three padding when the three items aren't three real things.
- Repeated sentence openings for artificial rhythm.
- Trailing `-ing` phrases that attach vague significance: "…, highlighting the importance of
  observability."
- False ranges: "from X to Y" where X and Y aren't on a scale.
- Empty transitions: `moreover`, `furthermore`, `additionally`, `it is worth noting`.

### Tone

- False suspense: "Here's the thing:", "Here's where it gets interesting", "What most people miss".
- Teacher voice: "Let's break this down", "Let's dive in", "Let's explore".
- Forced analogy: "Think of it as a…" when the direct explanation is shorter.
- Speculative invitation: "Imagine a world where…".
- Performative candor: "To be honest", "I'll be frank", fourth-wall asides.
- Obviousness claims in place of proof: "Clearly", "Obviously", "It is simple to see".
- Inflated stakes: not every change "transforms" anything.
- Vague attribution: "experts agree", "it is widely known". Name the source or drop it.
- Invented concept labels: coining "the X paradox" or "the Y gap" for a thing you haven't defined.
- Anthropomorphized abstractions: labels, states, or components that "need", "want", "tell",
  "know", or "see". Name the person or process that does the thing.

### Formatting and composition

- Bold-first bullets by default (`- **Fast:** it is fast`). Reserve bold labels for real field
  lists or glossaries.
- Dash pivots — like this — used repeatedly for drama. Use commas, parentheses, or two sentences.
- Decorative Unicode (→, ✓, ✨) where the project uses plain ASCII.
- Fractal summaries: intro to every section, recap after every section, "In summary" at the end.
- One thesis restated through many phrasings. Collapse to the strongest version plus evidence.
- Disguised listicles: paragraphs that are really "first, second, third". Either make it a list or
  write the actual relationship.
- Formulaic concession: "Despite these challenges, …" paragraphs that acknowledge a problem only to
  dismiss it.
- Comprehensive padding: caveats and checklist items that add bulk without changing any decision.
- Unsupported precision: exact-looking numbers, percentages, or rankings with no source.
- Generation residue: leftover chat framing, placeholders, `[citation needed]`-style tokens,
  instructions addressed to the requester.
- Repeated evidence-caveat template: "this supports but does not independently establish…" used
  identically on distinct claims. State the specific gap each time or don't caveat.
- Local style discontinuity: new prose in a different register, terminology, or heading style from
  the surrounding document. Match the local voice unless it blocks clarity.

## 7. Commit messages, PR descriptions, and handoffs

These are read later, out of context, by someone debugging or tracing a decision. Write for them.

**Commit messages.** Short imperative subject (≤72 chars ideally). Blank line. Body
wrapped at 72 explaining *why* and *what changed at the level of intent*, not a restatement of the
diff. `Fix retry loop replaying POST requests` over `Update client.py`. Of
course, its important to preserve local style.

**Make review artifacts standalone.** An issue, PR, or handoff must make sense without the chat
session that produced it. "As discussed" and "per the above" are dead links to a private context.

**Report verification honestly.** Distinguish ran / did not run / assumed. "Tests pass" when you
ran a subset is a false statement. "Ran `pytest tests/unit`; did not run integration tests (need
DB)" is a true one.

**Label speculation.** In review comments and handoffs, mark what is observed, what is inferred,
and what is unknown. A reader should never have to guess which of your sentences are facts.

## 8. Error messages

An error message is documentation read at the worst possible moment. It should let the reader act:

- Say what failed, on what, and why, in that order: `Failed to open config.toml: permission denied`.
- Include the value that caused the failure when safe to do so: `invalid port "80a": expected an
  integer 1–65535`.
- Suggest the fix when there is a specific one: `…; run 'tool init' to create it`.
- Do not include secrets, tokens, or private paths in messages that may be logged or shown.
- Preserve the underlying cause when wrapping (`…: <inner error>`); do not swallow it.
- Write for the person who will see it: a CLI user gets a sentence; a library caller gets a typed
  error plus a message.

## 9. Revising existing prose

**Read twice: structure first, sentences second.** Don't polish sentences inside a broken page
shape. The structure pass removes self-narration, collapses unnecessary headings, restores one
dominant mode, merges fragments, converts list-shaped explanation back to prose, and moves
maintainer detail out of the reader's first path. The sentence pass then cuts filler, ranking words,
stock transitions, and abstract nouns.

**Correctness and risk before style.** Wrong commands, stale paths, false guarantees, and hidden
prerequisites are blocking; awkward phrasing is not. Fix in that order and, in review, label
severity so the author can tell them apart.

**Preserve local voice.** Patch what needs changing. Don't re-tone a whole document to your default
register; keep its terms, density, formality, heading style, and examples unless they block clarity.
Grammatically correct but bland is a regression.

**Preserve intent over literalism.** When asked to reword something, keep the decision the original
was carrying. A rewrite that keeps the words but loses the "why" has failed.

**Don't mistake smooth for good.** Signs: the prose scans pleasantly but leaves no mental model;
every section sounds reasonable but nothing commits to concrete behavior; the same claim appears
three times in softer forms. Fix: cut repetition, merge sections, replace abstractions with the
specific example the text keeps circling.

**Treat AI-generated drafts as raw material.** Assume they contain false confidence, duplicate
sections, invented abstractions, over-taxonomy, hedged uncertainty, and bridge prose around links.
Your job is to verify, cut, restructure, and restore the local voice before anyone else spends
attention on it. Disclosing that a model drafted it does not substitute for doing this work.

**Reconstruct rationale before writing it.** If the code doesn't say why, check history, tests,
and discussion before drafting an explanation. Lead with the current mechanism; use history only to
support it, name a rejected alternative, or warn about a regression. Don't make the reader
reconstruct the present from a changelog.

## 10. Before handing off

Run through this on anything longer than a line:

- Does every comment tell the reader something the code doesn't? Delete the rest.
- Does the first sentence of each doc/section carry the useful point?
- Is every claim current behavior, and does its confidence match the evidence?
- Are commands, paths, defaults, and names real? Did you check?
- Did any behavior change leave nearby prose stale?
- Are there evaluative words (`simple`, `robust`, `best`) without a stated property behind them?
- Are there vague verbs (`handle`, `ensure`, `manage`) hiding the actual behavior?
- Is any abstraction or component doing something only a person or running code can do?
- Any contrast templates, false suspense, teacher voice, bold-first bullets, or fractal summaries?
- Is any explanation bulleted that should be prose, or any enumeration in prose that should be a
  list?
- Does the new text match the surrounding document's voice and terminology?
- Would this make sense to someone who was not in this conversation?

If a sentence survives all of that and you still aren't sure it earns its place, cut it and see if
anything was lost.
