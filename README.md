Note: This is a new, experimental version of the magpie backend which explores supporting fully dynamic interactive experiments. For the current stable version of magpie, please refer to the [magpie-backend](https://github.com/magpie-ea/magpie-backend) Github repo and the [project documentation site](https://magpie-experiments.org) instead.

# Magpie

For the frontend:
- Connect to the socket with params `participant_id` and `experiment_id`, just like with the previous version.
- If successful, it should receive a message `"waiting_in_queue"`. At this point it doesn't need to do anything.
- The message `"slot_available"`, with the payload `{slot_identifier: slot_identifier}` indicates that the server intends to assign this particular slot to the frontend. The frontend should reply with `take_free_slot`, with the payload `{slot_identifier: slot_identifier}` to indicate that it is taking up the slot and starting the experiment.
  - Note that the identifier received here consists of 3 parts: `{copy_count}_{identifier}_{player_count}`, e.g. `1_1:1:1_1`.
  - The "identifier" part can be any string. For an ULC experiment, it will be in the format: `{chain}:{variant}:{generation}"`.
- The frontend should send the message `"report_heartbeat"` periodically. If a heartbeat message has not been received in 2 minutes, the slot will be reset to "available".
- Upon finishing the experiment, the frontend should submit the results with the message `"submit_results"` and the payload of `{results: <results as an array of objects>}`.
  (Note that it's also possible to submit the results via a REST endpoint `POST /api/experiment_submissions/`, but there doesn't seem to be a need for that if we standardize all experiments to use the slots mechanism via web sockets, even the ones without interactivity.)
- To get the results for one particular slot, the frontend should send the message `"get_submission_for_slot"` and the payload of `{experiment_id: <id of the target experiment>, slot_identifier: <identifier of the target slot>}`. The results, if found, will be returned in the form of a payload of `{results: <results as an array of objects>}`.

Queueing of participants according to the order in which they joined, and automatic expansion and freeing of slots are implemented.



## Interactive experiments

- Join an interactive experiment at `"interactive_room:{experiment_id}:{slot_identifier}`, where the slot identifier should be the middle part of the identifier string received from the server.
- The experiment will start once the specified number of players for this slot has been reached.
- As before, the following message with payload will be accepted and broadcast to all participants in the same interactive room:
  - `"initialize_game"`
  - `"next_round"`
  - `"end_game"`

## To implement

- The heartbeat mechanism is implemented and would reset the slot corresponding to the participant. The resetting of interactive experiments might still need handling though.

## How to run the app locally
- Install Elixir and Phoenix framework following the guide at http://www.phoenixframework.org/
- Install Postgres and make sure it's running at port 5432
- Run `mix deps.get; mix ecto.setup`
- Run `mix phx.server` to start the server on `localhost:4000`
- Every time a database change is introduced with new migration files, run `mix ecto.migrate` again before starting the server.
