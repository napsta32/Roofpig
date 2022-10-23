
class Css
  light = "#ededed"
  dark  = "#bbb"
  shadow= "#ffffff"

  @CODE =
  """
<style>
.roofpig-button {
  padding: 0;
  outline: none;
  display: inline-block;
}

.roofpig-count {
  font-weight: normal;
  font-style: normal;
  text-align: right;
  float: right;
}

.roofpig-algtext {
  background-color: #eee;
  margin-bottom: 2px;
  font-weight: normal;
  font-style: normal;
  color: black;
}
.roofpig-past-algtext {
  background-color: #ff9;
}

.roofpig-help-button {
  font-size: 14px;
  height: 20px;
  width: 20px;
  position: absolute;
  right: 2px;
  top: 3px;

  color: #ddd;
  text-align: center;
  border-radius: 8px;
}
.roofpig-help-button:hover {
  color: black;
  background-color: rgba(220, 220, 220, 0.7);
}
.roofpig-help-button:active {
  background-color: #aaa;
}

.roofpig-help {
  position: absolute;
  top: -1px;
  white-space: nowrap;

  font-size: 10px;
  font-weight: normal;
  font-style: normal;
  color: black;
  text-align: left;
  background-color: rgba(255, 255, 255, 0.94);

  border: 1px solid #aaa;
  padding: 0 4px 4px 4px;
}
.roofpig-help div {
  margin: 2px 0;
}
.roofpig-help span {
  font-size: 11px;
  padding: 0 2px;
  background-color: #ddd;
}
</style>
    """