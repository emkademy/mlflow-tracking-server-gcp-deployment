from pathlib import Path
from random import random

import mlflow


def main():
    mlflow.set_tracking_uri("http://localhost:6100")
    experiment_name = "playground"

    try:
        mlflow.create_experiment(experiment_name)
    except mlflow.exceptions.RestException:  # type: ignore
        pass

    mlflow.set_experiment(experiment_name)

    with mlflow.start_run() as run:
        mlflow.log_param("test", 13)

        mlflow.log_metric("foo", random())
        mlflow.log_metric("foo", random() + 1)
        mlflow.log_metric("foo", random() + 2)

        tmp_txt_path = "tmp.txt"
        Path(tmp_txt_path).write_text("Everything is working!")

        mlflow.log_artifact(tmp_txt_path)

        Path(tmp_txt_path).unlink()


if __name__ == "__main__":
    main()
