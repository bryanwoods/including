class Module
  def including(mixin, options = {})
    include mixin and return unless options[:only] || options[:except]
    included_module = mixin.dup

    if options[:except]
      excluded_methods = options[:except]

      undefine(included_module, excluded_methods) and return
    else
      included_methods = included_module.instance_methods(false)
      excluded_methods = Array(options[:only]).map(&:to_sym)

      undefine(included_module, included_methods - excluded_methods)
    end
  end

  private

  def undefine(included_module, excluded_methods)
    (include included_module).tap do
      Array(excluded_methods).flatten.each do |meth|
        included_module.send(:undef_method, meth)
      end
    end
  end
end
