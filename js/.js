function dockerPs() {
  while (true) {
    const command = "sudo";
    const args = [
      "docker",
      "ps",
      "--format",
      '{"n": {{json .Names}}, "c": {{json .Command}}, "s": {{json .Status}}}',
    ];
    try {
      const ps = exec([command, ...args]).lines().map((l) => l.parseJson())
        .sort((a, b) => a.n.localeCompare(b.n));
      const result = [];
      for (const { n, c, s } of ps) {
        result.push({
          Name: n.style("lightblue"),
          Command: c.style("yellow"),
          Status: s.style(s.includes("Restarting") ? "red" : "green"),
        });
      }
      result.table().log();
    } catch (e) {
      print(e);
    }

    os.sleep(2000);
  }
}

function loadLogs(filePath, resultFile) {
  const fd = std.open(filePath, "r");

  let line;

  let json = "[";

  const lines = [];
  while (line = fd.getline()) {
    lines.push(line);
  }

  json += lines.reverse().join(",") + "]";

  json.write(resultFile);
  JSON.parse(json).stringify(null, 2).write(resultFile);
}

function redo(selection) {
  const commandsMemo = read(HOME + "/Documents/notes/commandsRepo.md");
  if (!commandsMemo) {
    throw Error(
      "Failed to read commands memo file at ~/Documents/commands.memo",
    );
  }
  const commands = [];
  const descriptions = [];
  commandsMemo.split("#")
    .forEach((commandAndDesc, i) => {
      if (!commandAndDesc.trim().length) return;
      const [description, command] = commandAndDesc.lines();
      commands.push(
        i.toString().style("grey") + " " + command +
          (" #" + description).style("grey"),
      );
      descriptions.push(description);
    });
  if (selection) {
    return print(descriptions[selection - 1]?.wrap());
  }

  try {
    const command = exec([
      "fzf",
      "--ansi",
      "--with-shell",
      "js",
      // '--preview="redo({1})"',
      // "--preview-window=up,1",
      // `--info-command="print(String({})?.split('#')?.[1]?.style(['bold','yellow']))"`,
      "--no-info",
      // `--info-command="print(${Number(COLUMNS)})"`,
      "--no-separator",
      "--no-border",
      "--header-border=rounded",
      // `"--bind=focus:transform-header:print(String({1})?.split('#')?.[1]?.wrap(${COLUMNS}).style(['bold','bright-white']))"`,
      `"--bind=focus:transform-header:redo({1})"`,
    ], {
      useShell: true,
      input: commands.join("\n"),
    });
    std.out.puts(command.split("#")[0].words().slice(1).join(" "));
  } catch {}
}

function fontPng(str) {
  os.exec();
}
