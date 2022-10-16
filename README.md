# Magpie

For the frontend:
- Connect to the socket with params `participant_id` and `experiment_id`, just like with the previous version.
- If successful, it should receive a message `"waiting_in_queue"`. At this point it doesn't need to do anything.
- The message `"slot_available"`, with the payload `{slot_identifier: slot_identifier}` indicates that the server intends to assign this particular slot to the frontend. The frontend should reply with `take_free_slot`, with the payload `{slot_identifier: slot_identifier}` to indicate that it is taking up the slot and starting the experiment.
- Upon finishing the experiment, the frontend should submit the results with the message `"submit_results"` and the payload of `{results: <results as an array of objects>}`.
  (Note that it's also possible to submit the results via a REST endpoint `POST /api/experiment_submissions/`, but there doesn't seem to be a need for that if we standardize all experiments to use the slots mechanism via web sockets, even the ones without interactivity.)
- To get the results for one particular slot, the frontend should send the message `"get_submission_for_slot"` and the payload of `{experiment_id: <id of the target experiment>, slot_identifier: <identifier of the target slot>}`. The results, if found, will be returned in the form of a payload of `{results: <results as an array of objects>}`.

Queueing of participants according to the order in which they joined, and automatic expansion and freeing of slots are implemented.

The slot identifier can be any string. For an ULC experiment, it will be in the format: `"#{copy_count}_#{chain}:#{variant}:#{generation}_#{player}"`.
