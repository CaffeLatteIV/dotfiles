import app from "ags/gtk4/app"
import css from "../style.css"
import { Astal, Gdk } from "ags/gtk4"
import { readFile } from "ags/file"
import { createPoll } from "ags/time"

function getJoke(): string {
  let fileName = "/home/caffelatte/dotfiles/banner/jokes"
  const file = readFile(fileName)
  const lines = file.split("\n").filter((line) => line.trim() !== "")
  if (lines.length === 0) {
    return "No jokes"
  }
  return lines[Math.floor(Math.random() * lines.length)]
}
export default function Bar(gdkmonitor: Gdk.Monitor) {
  const currentJoke = createPoll(getJoke(), 300000, () => getJoke())
  return (
    <window
      visible
      css={css}
      class={"quote-bar"}
      name="quote-bar"
      namespace="quote-bar"
      gdkmonitor={gdkmonitor}
      layer={Astal.Layer.BACKGROUND}
      exclusivity={Astal.Exclusivity.IGNORE}
      anchor={Astal.WindowAnchor.BOTTOM}
      application={app}
    >
      <box cssName="quote-container" class={"quote-bar"}>
        <box />
        <label label={currentJoke} wrap={true} />
        <box />
      </box>
    </window>
  )
}
