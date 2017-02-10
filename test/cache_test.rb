$LOAD_PATH.push File.expand_path('../../lib', __FILE__)

require 'cutest'
require 'webmock'
require 'rr/without_autohook'

require 'shariff_backend/cache'


scope do
  nonexists_key = '__ECeI__'
  key = 'name'
  key1 = 'fullname'
  original_value1 = 'gogogog'
  original_value2 = 'doe'

  setup do
  	ShariffBackend::Cache.set(key, original_value1)
  end

  scope 'Cache' do
    scope 'get' do
    	test 'return nil for nonexists key' do
	      val = ShariffBackend::Cache.get(nonexists_key)
	      assert_equal(nil, val)
	    end 

	    test 'return val for existing key' do
	      val = ShariffBackend::Cache.get(key)
	      assert_equal(original_value1, val)
	    end
    end

    scope 'exist?' do
    	test 'return false for nonexists key' do
	      val = ShariffBackend::Cache.exist?(nonexists_key)
	      assert_equal(false, val)
	    end 

	    test 'return true for existing key' do
	      val = ShariffBackend::Cache.exist?(key)
	      assert_equal(true, val)
	    end
    end

   	scope 'set' do
    	test 'set value for given key' do
	      ShariffBackend::Cache.set(key1, original_value2)
	      val = ShariffBackend::Cache.get(key1)
	      assert_equal(original_value2, val)
	    end 

	    test 'set block for given key' do
	      ShariffBackend::Cache.set(key1) do 
	      	original_value2
	      end
	      val = ShariffBackend::Cache.get(key1)
	      assert_equal(original_value2, val)
	    end 
		end
  end
end
