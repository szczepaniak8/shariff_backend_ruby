$LOAD_PATH.push File.expand_path('../../lib', __FILE__)

require 'cutest'
require 'webmock'
require 'rr/without_autohook'

require 'shariff_backend/cache'


scope do
  nonexists_key = '__ECeI__'
  key = 'name'
  key1 = 'fullname'
  key2 = 'test'
  key3 = 'test_'
  original_value1 = 'gogogog'
  original_value2 = 'doe'
  original_value3 = '_expires_'

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

		scope 'get_or_set' do
    	test 'get_or_set return assigned value' do
	      
	      val = ShariffBackend::Cache.set(key1, original_value2)
	      assert_equal(original_value2, val)
	    end 

	   
		end

		scope 'expires' do
    	test 'value is cached for entire expire time' do
	      ShariffBackend::Cache.set(key3, original_value3)
	      
	      assert_equal(original_value3, ShariffBackend::Cache.get(key3))
	      sleep 1
	      assert_equal(original_value3, ShariffBackend::Cache.get(key3))
	    end 

	    test 'value is released after expire time' do
	      ShariffBackend::Cache.set(key3, original_value3)
	      
	      assert_equal(original_value3, ShariffBackend::Cache.get(key3))
	      sleep 3
	      assert_equal(nil, ShariffBackend::Cache.get(key3))
	    end 
	    
		end
  end
end
