class Module
  def including(mixin, options = {})
    include mixin and return unless options[:only] || options[:except]
    included_module = mixin.dup

    excluded_methods = (
      options[:except] ||
      included_module.instance_methods(false) - options[:only]
    ).map(&:to_sym)

    (include included_module).tap do
      excluded_methods.each do |meth|
        included_module.send(:undef_method, meth)
      end
    end
  end
end
