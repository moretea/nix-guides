class String
  def bold
    "\033[1m" + self + "\033[0m"
  end

  def underline
    "\033[4m" + self + "\033[0m"
  end

  def red
    "\033[31m" + self + "\033[0m"
  end

  def yellow
    "\033[33m" + self + "\033[0m"
  end

  def blue
    "\033[34m" + self + "\033[0m"
  end
end
